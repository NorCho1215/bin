# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class power:
    pm_devs = dict()
    pm_subsets = dict()

    def __init__(self, i2c, variant=None, calibration=None):
        self.i2c = i2c
        return

    def reinit(self, list_of_rails = pm_devs.keys()):
        """
        Re-initializes devices
        """
        for rail in list_of_rails:
            pm_devs[rail].reinit()
        return

    def get_rail_names(self):
        """
        Returns a list of power rail names (power, voltage, current measurement)
        """
        return self.pm_devs.keys()

    def get_rail_power(self, rail_names):
        """
        Return a power consumption of a rail or a list of rails
        """
        if type(rail_names) == list:
            return [self.pm_devs[rail].power(blocking=True) for rail in rail_names]
        else:
            return self.pm_devs[rail_names].power(blocking=True)

    def get_rail_voltage(self, rail_names):
        """
        Return a voltage of a rail or a list of rails
        """
        if type(rail_names) == list:
            return [self.pm_devs[rail].bus_voltage()/1000.0 for rail in rail_names]
        else:
            return self.pm_devs[rail_names].bus_voltage()/1000.0

    def get_rail_current(self, rail_names):
        """
        Return a current of a rail or a list of rails
        """
        if type(rail_names) == list:
            return [self.pm_devs[rail].current() for rail in rail_names]
        else:
            return self.pm_devs[rail_names].current()

    def get_power(self, subset_name):
        """
        Returns power of given power "subset"
        """
        rail_powers = [self.get_rail_power(rail_name[1:]) for rail_name in self.pm_subsets[subset_name]]
        operators = [rail_name[0] for rail_name in self.pm_subsets[subset_name]]
        power = 0
        for (o, p) in zip(operators, rail_powers):
            if o == '+':
                power = power + p
            else:
                power = power - p
        return power

    def get_power_names(self):
        """
        Return a list of power "subsets"
        """
        return self.pm_subsets.keys()

    def set_rail_imax(self, rail_name, imax):
        """
        Set maximum measurable current of a rail (use lowest possible as it gives best accuracy)
        """
        self.pm_devs[rail_name].set_imax(imax)

    def get_rail_imax(self, rail_name):
        return self.pm_devs[rail_name]._imax

    def set_sampling_profile(self, profile):
        for dev in self.pm_devs.values():
            dev.set_sampling_profile(profile)
