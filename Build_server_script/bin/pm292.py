# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
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

class pm292(debug_board):
    """PM292"""

    supported_targets = ['cardhu', 'enterprise', 'pm292']

    def __init__(self, serial = None,  # debug board identifier
                 target = None, # attached target board [pluto | dalmore | ceres]
                 variant = None, # Variant of target board (e.g. "daq")
                 calibration = None, # Calibration scheme to use for power monitors @ target boards
                 enable_usb = True
                 ):

        debug_board.__init__(self, target, variant, calibration)

        self.i2c = I2C(upper_nibble_dir=0xf,
                       upper_nibble_val=0x8 if enable_usb else 0,
                       usb_vid = 0x0403, usb_pid=0x6010, serial = serial)

        # I2C I/O expanders
        self.U3B1 = TCA9539(self.i2c, 0x74)
        self.U3C1 = TCA9539(self.i2c, 0x75)

        #   name    :          device, port, bit, polarity
        self.buttons = {
            "SYS_RESET"      :  [self.i2c.mpsse, 1, 4, 1],
            "FORCE_RECOVERY" :  [self.i2c.mpsse, 1, 5, 1],
            "ONKEY"          :  [self.i2c.mpsse, 1, 6, 1],
            "DBGIRQ"         :  [self.i2c.mpsse, 1, 7, 1]
            }

        #    name   :   device_r,  device_w, port, bit
        self.IOs = {
            "GPIO0" :  [self.U3B1, self.U3C1,  0,   0],
            "GPIO1" :  [self.U3B1, self.U3C1,  0,   1],
            "PMSEL"  :  [self.i2c.mpsse, self.i2c.mpsse, 0, 4],
            "FACNOK" :  [self.i2c.mpsse, self.i2c.mpsse, 0, 5],
            "MFGMODE":  [self.i2c.mpsse, self.i2c.mpsse, 0, 6],
            "PWRSW"  :  [self.i2c.mpsse, self.i2c.mpsse, 0, 7],
            }

    def hold_button(self, button_name):
        device, port, bit, polarity = self.buttons[button_name]
        assert polarity==0 or polarity==1

        # value to polarity and direction to output
        device.writeb(port, bit, polarity)
        device.dirb(port, bit, 0)

    def release_button(self, button_name):
        device, port, bit, polarity = self.buttons[button_name]
        assert polarity==0 or polarity==1

        # value to 1^polarity and direction to input
        device.writeb(port, bit, 1^polarity)
        device.dirb(port, bit, 1)

    def set_IO(self, io_name, value):
        assert value==0 or value==1 or value==None
        device_r, device_w, port, bit = self.IOs[io_name]

        if value == None:
            device_w.dirb(port, bit, 1)
        elif value == 1:
            device_w.writeb(port, bit, 1)
            device_w.dirb(port, bit, 0)
        else:
            device_w.writeb(port, bit, 0)
            device_w.dirb(port, bit, 0)

    def get_IO(self, io_name):
        device_r, device_w, port, bit = self.IOs[io_name]
        return device_r.readb(port, bit)

    def is_VDD_CORE_on(self):
        return False

    def is_VDD_CPU_on(self):
        return False

    def enable_USB(self):
        self.set_IO("PWRSW", 1)

    def disable_USB(self):
        self.set_IO("PWRSW", 0)

