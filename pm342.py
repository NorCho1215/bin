# Copyright (c) 2013-2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ftdi_i2c_lin import I2C
from TCA9539 import TCA9539
from debug_board import debug_board
import time

class pm342(debug_board):
    """PM342"""

    supported_targets = ['pluto', 'dalmore', 'ceres', 'atlantis', 'ardbeg', 'norrin', 'bowmore', 'e1765',
                         'e1784', 'e2220', 'e2290', 'e2581', 'e3301', 'p3310', 'pm342']

    def __init__(self, serial = None,  # debug board identifier
                 target = None, # attached target board
                 variant = None, # Variant of target board (e.g. "daq")
                 calibration = None, # Calibration scheme to use for power monitors @ target boards
                 enable_usb = True
                 ):

        debug_board.__init__(self, target, variant, calibration)

        self.i2c = I2C(upper_nibble_dir=0x9,
                       upper_nibble_val=0x9 if enable_usb else 0x1,
                       usb_vid = 0x0403, usb_pid = 0x6011, serial = serial)

        # I2C I/O expanders
        self.U8 = TCA9539(self.i2c, 0x74)
        self.U27 = TCA9539(self.i2c, 0x75)

        #   name    :          device, port, bit, polarity
        self.buttons = {
            "SYS_RESET" :      [self.U8,  0, 3, 0],
            "ONKEY" :          [self.U8,  1, 4, 0],
            "FORCE_RECOVERY" : [self.U8,  1, 3, 0],
            "R0C0"  :          [self.U27, 0, 7, 1],
            "R0C1"  :          [self.U27, 1, 0, 1],
            "R0C2"  :          [self.U27, 1, 1, 1],
            "R1C0"  :          [self.U27, 1, 2, 1],
            "R1C1"  :          [self.U27, 1, 3, 1],
            "R1C2"  :          [self.U27, 1, 4, 1],
            "R2C0"  :          [self.U27, 1, 5, 1],
            "R2C1"  :          [self.U27, 1, 6, 1],
            "R2C2"  :          [self.U27, 1, 7, 1],
            "FORCE_OFF" :      [self.i2c.mpsse, 0, 6, 0]
            }

        #    name   :    device, read port, read bit, write port, write bit
        self.IOs = {
            "GPIO1" :       [self.U8,     0,       0,          1,         0], #R/W
            "GPIO2" :       [self.U8,     0,       1,          1,         1], #R/W
            "GPIO3" :       [self.U8,     0,       2,          1,         2], #R/W
            "PMU_RST_OUT" : [self.U8,     0,       4,         -1,        -1], #RO
            "CPU_PWR_REQ" : [self.U8,     0,       6,         -1,        -1], #RO
            "CPU_CORE_REQ": [self.U8,     0,       7,         -1,        -1], #RO
            "DBG_IRQ" :     [self.U8,     1,       5,          1,         5], #R/W
            "V_CORE_LT_P6": [self.U8,     1,       6,         -1,        -1], #RO
            "V_CPU_LT_P6" : [self.U8,     1,       7,         -1,        -1], #RO
            "PM_BUS_SEL"  : [self.i2c.mpsse,   0,       4,          0,         4], #R/W
            "FRC_AC_NOT_OK":[self.i2c.mpsse,   0,       6,          0,         6], #R/W
            "USB_SW_EN"   : [self.i2c.mpsse,   0,       7,          0,         7] #R/W
            }
        return

    def hold_button(self, button_name):
        device, port, bit, polarity = self.buttons[button_name]

        # value to polarity and direction to output
        device.writeb(port, bit, polarity)
        device.dirb(port, bit, 0)

    def release_button(self, button_name):
        device, port, bit, polarity = self.buttons[button_name]

        # value to 1^polarity and direction to input
        device.writeb(port, bit, 1^polarity)
        device.dirb(port, bit, 1)

    def set_IO(self, io_name, value):
        assert value==0 or value==1 or value==None
        device, read_port, read_bit, write_port, write_bit = self.IOs[io_name]

        if write_port < 0 or write_bit < 0:
            return

        if value == None:
            device.dirb(write_port, write_bit, 1)
        elif value == 1:
            device.writeb(write_port, write_bit, 1)
            device.dirb(write_port, write_bit, 0)
        else:
            device.writeb(write_port, write_bit, 0)
            device.dirb(write_port, write_bit, 0)

    def get_IO(self, io_name):
        device, read_port, read_bit, write_port, write_bit = self.IOs[io_name]
        return device.readb(read_port, read_bit)

    def is_VDD_CORE_on(self):
        return not self.get_IO("V_CORE_LT_P6")

    def is_VDD_CPU_on(self):
        return not self.get_IO("V_CPU_LT_P6")

    def enable_USB(self):
        self.set_IO("USB_SW_EN", 1)

    def disable_USB(self):
        self.set_IO("USB_SW_EN", 0)
