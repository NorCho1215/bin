# Copyright (c) 2013-2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

import time
import sys

class debug_board:
    power = None
    buttons = dict()
    IOs = dict()

    def __init__(self, target = None, variant = None, calibration = None):
        self.target = target
        self.variant = variant
        self.calibration = calibration
        self.powermon_init = False
        return

    def target_power_on(self):
        """Power On target"""
        if self.target=="ceres" or self.target=="atlantis" or self.target=="p3310" or self.target=="e3301":
            self.target_reset()
        elif self.target=="e3340":
            self.push_button('ONKEY')
            time.sleep(1)
            self.push_button('SYS_RESET')
        else:
            self.push_button('ONKEY')

    def target_power_off(self):
        """Power Off target"""
        if self.target=="norrin" or self.target=="e3301" or self.target=="e3340":
            self.push_button('ONKEY', delay=12)
        elif self.target=="p3310":
            self.push_button('SYS_RESET')
        else:
            self.push_button('FORCE_OFF')

    def target_reset(self):
        """
        Reset the target system
        """
        if self.target == 'atlantis':
            self.hold_button('SYS_RESET')
            time.sleep(0.2)
            self.hold_button('FORCE_RECOVERY')
            time.sleep(0.2)
            self.push_button('FORCE_OFF')
            time.sleep(0.5)
            self.release_button('SYS_RESET')
            time.sleep(0.2)
            self.release_button('FORCE_RECOVERY')
        elif self.target == 'ceres':
            if self.variant and self.variant.upper() in ['A04', 'A05']:
                self.push_button('FORCE_OFF')
                time.sleep(0.2)
                self.hold_button('SYS_RESET')
                time.sleep(0.2)
                self.hold_button('FORCE_RECOVERY')
                time.sleep(0.2)
                self.push_button('ONKEY')
                time.sleep(2.0)
                self.release_button('SYS_RESET')
                time.sleep(0.2)
                self.release_button('FORCE_RECOVERY')
            else:
                # Variant is A00, A01, A02 or A03
                # Assume USB cable connected scenario
                self.hold_button('SYS_RESET')
                time.sleep(0.2)
                self.hold_button('FORCE_RECOVERY')
                time.sleep(0.2)
                self.push_button('FORCE_OFF')
                time.sleep(0.5)
                self.release_button('SYS_RESET')
                time.sleep(0.2)
                self.release_button('FORCE_RECOVERY')
        elif self.target == 'norrin':
            self.push_button('SYS_RESET')
            self.push_button('ONKEY')
        elif self.target == 'p3310' or self.target == 'e3301':
            self.push_button('SYS_RESET')
            self.push_button('ONKEY')
        else:
            self.push_button('SYS_RESET')
        return

    def target_recovery_mode(self):
        """
        Sets the target board into recovery mode for flashing
        """
        if self.target == 'atlantis':
            self.hold_button('SYS_RESET')
            time.sleep(0.2)
            self.push_button('FORCE_OFF')
            time.sleep(0.2)
            self.release_button('SYS_RESET')
        elif self.target == 'ceres':
            if self.variant and self.variant.upper() in ['A04', 'A05']:
                self.push_button('FORCE_OFF')
                time.sleep(0.2)
                self.hold_button('SYS_RESET')
                time.sleep(0.2)
                self.push_button('ONKEY')
                time.sleep(2.0)
                self.release_button('SYS_RESET')
            else:
                # Variant is A00, A01, A02 or A03
                # Assume USB cable connected scenario
                self.hold_button('SYS_RESET')
                time.sleep(0.2)
                self.push_button('FORCE_OFF')
                time.sleep(0.2)
                self.release_button('SYS_RESET')
        elif self.target == 'norrin':
            self.hold_button('FORCE_RECOVERY')
            time.sleep(0.2)
            self.hold_button('SYS_RESET')
            time.sleep(0.2)
            self.hold_button('ONKEY')
            time.sleep(0.2)
            self.release_button('SYS_RESET')
            time.sleep(0.2)
            self.release_button('ONKEY')
            time.sleep(0.2)
            self.release_button('FORCE_RECOVERY')
        elif self.target == 'p3310' or self.target == 'e3301':
            self.push_button('SYS_RESET')
            time.sleep(0.2)
            self.hold_button('FORCE_RECOVERY')
            time.sleep(0.2)
            self.push_button('ONKEY')
            time.sleep(0.2)
            self.release_button('FORCE_RECOVERY')
        else:
            # Pluto, Dalmore, Cardhu, and Enterprise
            self.hold_button('FORCE_RECOVERY')
            time.sleep(0.1)
            self.hold_button('SYS_RESET')
            time.sleep(0.1)
            self.release_button('SYS_RESET')
            time.sleep(0.1)
            self.release_button('FORCE_RECOVERY')

    def push_button(self, button, delay=0.25):
        self.hold_button(button)
        time.sleep(delay)
        self.release_button(button)
        return

    def get_button_names(self):
        """
        Return list of available push buttons on debug board
        """
        return self.buttons.keys()

    def get_IO_names(self):
        """
        Return list of available GPIOs on debug board
        """
        return self.IOs.keys()

    def hold_button(self, button):
        return

    def release_button(self, button):
        return

    def set_IO(self, io_name, value):
        """
        Drive IO pin
         value=0 - drive low
         value=1 - drive high
         value=None - disables output driver (IO configured as input)
        """
        return

    def get_IO(self, io_name):
        return

    def is_VDD_CORE_on(self):
        return

    def is_VDD_CPU_on(self):
        return

    def init_power(self):
        """One-time initialization of INA power monitors"""
        if self.powermon_init:
            return

        self.powermon_init = True

        if self.target == 'pm342' or self.target == 'pm292' or self.target == None:
            self.power = None
        else:
            try:
                target_name  = self.target + '_power'
                board_module = __import__(target_name)
                board_power  = getattr(board_module, target_name)
                self.power   = board_power(i2c = self.i2c, variant = self.variant,
                                           calibration = self.calibration)
            except IOError:
                raise Exception("Unsupported target type %s" % self.target)
            except:
                print "Error:", sys.exc_info()[0], sys.exc_info()[1]
                raise

    def get_rail_names(self):
        """
        Returns a list of power rail names (power, voltage, current measurement)
        """
        self.init_power()
        if self.power:
            return self.power.get_rail_names()
        else:
            return []

    def get_rail_power(self, rail_names):
        """
        Return a power consumption of a rail or a list of rails
        """
        self.init_power()
        if self.power:
            return self.power.get_rail_power(rail_names)
        else:
            return None

    def get_rail_voltage(self, rail_names):
        """
        Return a voltage of a rail or a list of rails
        """
        self.init_power()
        if self.power:
            return self.power.get_rail_voltage(rail_names)
        else:
            return None

    def get_rail_current(self, rail_names):
        """
        Return a current of a rail or a list of rails
        """
        self.init_power()
        if self.power:
            return self.power.get_rail_current(rail_names)
        else:
            return None

    def get_power(self, subset_name):
        """
        Returns power of given power subset
        """
        self.init_power()
        if self.power:
            return self.power.get_power(subset_name)
        else:
            return None

    def get_power_names(self):
        """
        Return a list of power subsets (e.g. Total_Power, CPU, ...)
        """
        self.init_power()
        if self.power:
            return self.power.get_power_names()
        else:
            return []

    def set_sampling_profile(self, profile, avg=None, ct=None):
        self.init_power()
        if self.power:
            if avg and ct:
                self.power.set_sampling_profile(profile, avg, ct)
            else:
                self.power.set_sampling_profile(profile)

    def __repr__(self):
        if self.variant:
            return '<Board:{0}, variant:{1}>'.format(self.target, self.variant)
        return '<Board:{0}>'.format(self.target)
