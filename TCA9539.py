# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class TCA9539:
    # definitions for port direction
    OUT = 0
    IN = 1

    def __init__(self, i2c, i2c_addr):
        self.i2c = i2c
        self.i2c_addr = i2c_addr
        return

    def read_reg(self, command):
        self.i2c.send_bytes(self.i2c_addr, [command], issue_stop=False)
        return ord(self.i2c.read_bytes(self.i2c_addr, 1)[0])

    def write_reg(self, command, val):
        self.i2c.send_bytes(self.i2c_addr, [command, val])
        return

    def readp(self, port):
        assert port==0 or port==1
        return self.read_reg(0x0+port)

    def writep(self, port, val):
        assert port==0 or port==1
        self.write_reg(0x2+port, val & 0xff)
        return

    def dirp(self, port, dir):
        assert port==0 or port==1
        self.write_reg(0x6+port, dir & 0xff)
        return

    def readb(self, port, bit):
        assert port==0 or port==1
        assert bit>=0 and bit < 8
        inreg = self.read_reg(0x0+port)
        if inreg & (2**bit): return 1
        else: return 0

    def writeb(self, port, bit, val):
        assert port==0 or port==1
        assert val==0 or val==1
        assert bit>=0 and bit < 8
        outreg = self.read_reg(0x2+port)
        if val: outreg |= 2**bit & 0xff
        else: outreg &= ~(2**bit) & 0xff
        self.write_reg(0x2+port, outreg)
        return

    def dirb(self, port, bit, dir):
        assert port==0 or port==1
        assert dir==0 or dir==1
        assert bit>=0 and bit < 8
        confreg = self.read_reg(0x6+port)
        if dir: confreg |= (2**bit) & 0xff
        else: confreg &= ~(2**bit) & 0xff
        self.write_reg(0x6+port, confreg)
        return
