# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina219 import INA219
from power import power

class cardhu_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        self.pm_devs = {
            "VDD_AC_BAT" : INA219(self.i2c, 0x40, 0.010, "VDD_AC_BAT", imax=3000),
            "VDD_DRAM_IN" : INA219(self.i2c, 0x41, 0.010, "VDD_DRAM_IN", imax=500),
            "VDD_BKL_IN" : INA219(self.i2c, 0x42, 0.030, "VDD_BKL_IN", imax=500),
            "VDD_CPU_IN" :  INA219(self.i2c, 0x43, 0.020, "VDD_CPU_IN", imax=3000),
            "VDD_CORE_IN" : INA219(self.i2c, 0x44, 0.030, "VDD_CORE_IN", imax=1500),
            "VDD_DISP_IN" : INA219(self.i2c, 0x45, 0.050, "VDD_DISP_IN", imax=800),
            "VDD_3V3_TEGRA" : INA219(self.i2c, 0x46, 0.030, "VDD_3V3_TEGRA", imax=200),
            "VDD_OTHER_PMU_IN" : INA219(self.i2c, 0x47, 0.020, "VDD_OTHER_PMU_IN", imax=2000),
            "VDD_1V8_TEGRA" : INA219(self.i2c, 0x48, 0.050, "VDD_1V8_TEGRA", imax=200),
            "VDD_1V8_OTHER" : INA219(self.i2c, 0x49, 0.020, "VDD_1V8_OTHER", imax=2000)
           }

        self.pm_subsets = {
            "Total" : ["+VDD_AC_BAT"],
            "Backlight" : ["+VDD_BKL_IN"],
            "Display_Subsystem" : ["+VDD_BKL_IN", "+VDD_DISP_IN"],
            "DRAM" : ["+VDD_DRAM_IN"],
            "CPU" : ["+VDD_CPU_IN"],
            "CORE" : ["+VDD_CORE_IN"],
            "Tegra_Subsystem" : [
                "+VDD_CPU_IN",
                "+VDD_CORE_IN",
                "+VDD_DRAM_IN",
                "+VDD_3V3_TEGRA",
                "+VDD_OTHER_PMU_IN",
                "-VDD_1V8_OTHER"
                ],
            "All_Rails" : ['+'+x for x in self.pm_devs.keys()]
            }
        return

