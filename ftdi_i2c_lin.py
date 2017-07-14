# Copyright (c) 2013-2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

import ftdi
import struct
import time
import os

SCL = 0x01
SDA = 0x02

# MPSSE command definitions
BYTE_OUT_MSB_ON_RISING_EDGE = 0x10
BYTE_OUT_MSB_ON_FALLING_EDGE = 0x11
BIT_OUT_MSB_ON_RISING_EDGE = 0x12
BIT_OUT_MSB_ON_FALLING_EDGE = 0x13
BYTE_IN_MSB_ON_RISING_EDGE = 0x20
BYTE_IN_MSB_ON_FALLING_EDGE = 0x24
BIT_IN_MSB_ON_RISING_EDGE = 0x22
BIT_IN_MSB_ON_FALLING_EDGE = 0x26
SEND_IMMEDIATE = 0x87


class MPSSE(object):
    def __init__(self, in_edge=1, out_edge=1, lsb_first=0, clock_rate_khz=100,
                 three_phase_clock=False, adaptive_clock=False, verbose=False,
                 usb_vid = 0x0403, usb_pid = 0x6011, serial=None, pval = 0,
                 pdir = 0):
        # hack
        self._ftdic = ftdi.ftdi_context()

        ftdic = self._ftdic

        ret = ftdi.ftdi_init(ftdic)
        if ret < 0:
            raise IOError("ftdi_init failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))

        ret = ftdi.ftdi_usb_open_desc(ftdic, usb_vid, usb_pid, None, serial)
        if ret < 0:
            if serial is None: serial = ''
            raise IOError("Unable to open device %04x:%04x:%s, %s" %
                          (usb_vid, usb_pid, serial,
                           ftdi.ftdi_get_error_string(ftdic)))

        # "shadow registers" for port values and directions
        self.pval=[0, 0]
        self.pdir=[0, 0]

        ret = ftdi.ftdi_usb_reset(ftdic)
        if ret < 0:
            raise IOError("ftdi_usb_reset failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        ret = ftdi.ftdi_write_data_set_chunksize(ftdic, 65535)
        if ret < 0:
            raise IOError("ftdi_write_data_set_chunksize failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        ret = ftdi.ftdi_read_data_set_chunksize(ftdic, 65535)
        if ret < 0:
            raise IOError("ftdi_read_data_set_chunksize failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        ret = ftdi.ftdi_set_event_char(ftdic, 0, 0)
        if ret < 0:
            raise IOError("ftdi_set_event_char failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        ret = ftdi.ftdi_set_error_char(ftdic, 0, 0)
        if ret < 0:
            raise IOError("ftdi_set_error_char failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        ret = ftdi.ftdi_set_latency_timer(ftdic, 32)
        if ret < 0:
            raise IOError("ftdi_set_latency_timer failed: %s" %
                          (ftdi.ftdi_get_error_string(ftdic)))
        for mode in [0, 2]:
            ret = ftdi.ftdi_set_bitmode(ftdic, 0, mode)
            if ret < 0:
                raise IOError("ftdi_set_bitmode failed: %s" %
                              (ftdi.ftdi_get_error_string(ftdic)))

        self.set_port(pval, pdir)
        self.purge_usb_buffers()

        time.sleep(50.0/1000.0)

        self._sync(verbose)

        # Following commands setup the FTDI chip for I2C mode
        # These are described in the FTDI AN_108 Application Note
        self.ftdi_write_data('\x8b') # enable clock divide by 5 for 60Mhz master
        self.ftdi_write_data('\x97') # disable adaptive clocking
        if three_phase_clock:
            self.ftdi_write_data('\x8c') # enable three phase clocking for I2C

        self.set_clock_rate(clock_rate_khz)

        self.ftdi_write_data('\x85') # disable loop back connection

        time.sleep(30.0/1000.0)

        self.purge_usb_buffers()

    def ftdi_write_data(self, data):
        ret = ftdi.ftdi_write_data(self._ftdic, data, len(data))
        if ret < 0:
            raise IOError("ftdi_write_data failed: %s" %
                          (ftdi.ftdi_get_error_string(self._ftdic)))
        return ret

    def ftdi_read_data(self, len):
        buf = ''.zfill(len)
        ret = ftdi.ftdi_read_data(self._ftdic, buf, len)
        if ret < 0:
            raise IOError("ftdi_read_data failed: %s" %
                          (ftdi.ftdi_get_error_string(self._ftdic)))
        if ret < len:
            raise IOError("ftdi_read_data failed to get enough bytes: Expecting %d, Received %d" %
                          (len, ret))
        return buf[0:ret]

    def purge_usb_buffers(self):
        ret = ftdi.ftdi_usb_purge_buffers(self._ftdic)
        if ret < 0:
            raise IOError("ftdi_usb_purge_buffers failed: %s" %
                          (ftdi.ftdi_get_error_string(self._ftdic)))

    def set_clock_rate(self, clk_rate_khz):
        div = int(2 * 12000 / (clk_rate_khz*2*3)) - 1
        s = struct.pack("<BH", 0x86, div)
        self.ftdi_write_data(s)

    def _sync(self, verbose):
        ftdic = self._ftdic
        data = ""
        data = data.zfill(2)
        for j in xrange(1,100):
            ftdi.ftdi_usb_purge_rx_buffer(ftdic)
            self.ftdi_write_data('\xaa') # send a bad command
            for i in xrange(0,1000):
                data = self.ftdi_read_data(2)
                if len(data) == 2:
                    break
            if '\xfa\xaa' == data:
                break
        if verbose:
            print "synced after %d tries" % j
        if j == 99:
            raise AssertionError("failed to sync!")

    def set_port(self, value, direction, low_byte = True, multiplier=4):
        assert value >=0 and value < 256
        assert direction >=0 and direction < 256

        if low_byte: port = 0
        else: port = 1
        # update shadow registers
        self.pval[port] = value
        self.pdir[port] = direction

        if low_byte:
            cmd = struct.pack("<BBB", 0x80, value, direction)
        else:
            cmd = struct.pack("<BBB", 0x82, value, direction)
        cmd = cmd * multiplier
        self.ftdi_write_data(cmd)

    def read_port(self, low_byte = True):
        if low_byte:
            self.ftdi_write_data('\x81')
        else:
            self.ftdi_write_data('\x83')
        return self.ftdi_read_data(1)

    def readp(self, port):
        assert port==0 or port==1
        return ord(self.read_port(low_byte = not port))

    def writep(self, port, val):
        assert port==0 or port==1
        val = (0xf0 & port) | (0x0f & self.pval[port])
        self.set_port(val, self.pdir[port], low_byte = not port)

    def dirp(self, port, dir):
        assert port==0 or port==1
        dir = ~dir
        dir = (0xf0 & dir) | (0x0f & self.pdir[port])
        self.set_port(self.pval[port], dir, low_byte = not port)

    def readb(self, port, bit):
        """
        Read state of one bit (0..7) in port 0 or 1
        """
        assert port==0 or port==1
        assert bit>=0 and bit < 8

        i = self.readp(port)
        if i & (2**bit): return 1
        else: return 0

    def writeb(self, port, bit, val):
        """
        Set state of one bit (4..7) in port 0 or 1
        """
        assert port==0 or port==1
        assert val==0 or val==1
        assert bit>=4 and bit < 8
        pval = self.pval[port]
        if val: pval |= 2**bit & 0xff
        else: pval &= ~(2**bit) & 0xff
        self.set_port(pval, self.pdir[port], low_byte = not port)


    def dirb(self, port, bit, dir):
        """
        Set direction of one bit (4..7) in port 0 or 1
        0 = output, 1 = input
        """
        assert port==0 or port==1
        assert dir==0 or dir==1
        assert bit>=4 and bit < 8
        pdir = self.pdir[port]

        if dir==0: pdir |= (2**bit) & 0xff
        else: pdir &= ~(2**bit) & 0xff
        self.set_port(self.pval[port], pdir, low_byte = not port)


class I2C(object):
    def __init__(self, verbose=False, upper_nibble_dir=0xd, upper_nibble_val=0xc, usb_vid = 0x0403, usb_pid = 0x6011, serial=None):
        self.mpsse = MPSSE(0,1,0,three_phase_clock=True,verbose=verbose, usb_vid = usb_vid, usb_pid = usb_pid, serial=serial, pval = upper_nibble_val<<4, pdir = upper_nibble_dir<<4)
        self.outbuf = bytearray()

    def setb(self, scl = None, sda = None, multiplier=1):
        assert scl==0 or scl==1 or scl==None
        assert sda==0 or sda==1 or sda==None

        pval = self.mpsse.pval[0]
        pdir = self.mpsse.pdir[0]
        if scl==0:
            pval = pval & ~SCL
            pdir = pdir |  SCL
        elif scl==1:
            pval = pval | SCL
            pdir = pdir | SCL
        else:
            pval = pval | SCL
            pdir = pdir & ~SCL

        if sda==0:
            pval = pval & ~SDA
            pdir = pdir |  SDA
        elif sda==1:
            pval = pval |  SDA
            pdir = pdir |  SDA
        else:
            pval = pval | SDA
            pdir = pdir & ~SDA

        self.outbuf += struct.pack("<BBB", 0x80, pval, pdir) * multiplier

    def data_out(self, data):
        self.outbuf += struct.pack("<BHs", BYTE_OUT_MSB_ON_FALLING_EDGE, len(data) - 1, data)

    def data_in(self, length):
        self.outbuf += struct.pack("<BH", BYTE_IN_MSB_ON_RISING_EDGE, length - 1)

    def bit_out(self, bit):
        self.outbuf += struct.pack("<BBB", BIT_OUT_MSB_ON_FALLING_EDGE, 0, bit)

    def bit_in(self):
        self.outbuf += struct.pack("<BB", BIT_IN_MSB_ON_RISING_EDGE, 0)

    def start_bit(self):
        self.mpsse.purge_usb_buffers()
        self.setb(scl = None, sda = None)
        self.setb(scl = None, sda = 0, multiplier=2)
        self.setb(scl = 0, sda = 0)

    def stop_bit(self):
        self.setb(scl=0, sda=0)
        self.setb(scl=None, sda=0)
        self.setb(scl=None, sda=None)

    def sync(self, recv_length=0):
        if self.outbuf:
            self.outbuf += '%c' % SEND_IMMEDIATE
            self.mpsse.ftdi_write_data(str(self.outbuf))
            self.outbuf = bytearray()
        if recv_length > 0:
            self.inbuf = self.mpsse.ftdi_read_data(recv_length)

    def send_byte(self, byte):
        self.setb(scl = 0, sda = 0) # SDA output
        self.data_out("%c" % byte)
        self.setb(scl = 0, sda = None) # SDA input
        self.bit_in()
        self.sync(recv_length=1)

        nack = self.inbuf[0]
        if (ord(nack) & 1):
            raise AssertionError("No Acknowledge from Device")

    def send_bytes(self, addr, data, issue_start=True,  issue_stop=True):
        if issue_start:
            self.start_bit()

        self.send_byte(addr << 1 | 0)

        for byte in data:
            self.send_byte(byte)

        if issue_stop:
            self.stop_bit()

        self.sync()

    def read_byte(self, ack=True):
        self.setb(scl = 0, sda = None) # SDA input
        self.data_in(1)
        self.setb(scl = 0, sda = 0)  # SDA output

        if ack: self.bit_out(0)
        else:   self.bit_out(0xff)

    def read_bytes(self, addr, length, issue_start=True, issue_stop=True):
        assert length > 0
        if issue_start:
            self.start_bit()

        self.send_byte((addr << 1) | 1)
        for i in range(length - 1):
            self.read_byte(ack=True)
        self.read_byte(ack=False)

        self.stop_bit()
        self.sync(length)
        return self.inbuf
