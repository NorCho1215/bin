# Copyright (c) 2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina226 import INA226
from power import power

class e2290_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For e2290 (Hawkeye T210), the i2c bus on PM342 is directly connected to the AUX_1 bus.
        self.i2c = i2c

        # Hawkeye (e2290)
        self.pm_devs = {
            # total battery output
            "VDD_BAT_CHG" : INA226(i2c, 0x41, 0.005, "VDD_BAT_CHG", imax=9000),
            # CPU
            "VDD_SYS_BUCKCPU" : INA226(i2c, 0x42, 0.002, "VDD_SYS_BUCKCPU", imax=4197),
            # GPU
            "VDD_SYS_BUCKGPU" : INA226(i2c, 0x43, 0.002, "VDD_SYS_BUCKGPU", imax=2798),
            # SD0 - SOC
            "VDD_SYS_SD0" : INA226(i2c, 0x48, 0.005, "VDD_SYS_SD0", imax=1399),
            # SD1 - DDR
            "VDD_SYS_SD1" : INA226(i2c, 0x49, 0.01, "VDD_SYS_SD1", imax=866),
            # MDM
            "VDD_SYS_BYPASSBOOSTMDM" : INA226(i2c, 0x4b, 0.005, "VDD_SYS_BYPASSBOOSTMDM", imax=3439),
            # Backlight
            "VDD_SYS_BOOSTBL" : INA226(i2c, 0x4c, 0.03, "VDD_SYS_BOOSTBL", imax=481),
            # COM
            "VDD_SYS_COM" : INA226(i2c, 0x4e, 0.01, "VDD_SYS_COM", imax=542),
            # 5V0
            "VDD_SYS_BOOST5V0" : INA226(i2c, 0x4f, 0.01, "VDD_SYS_BOOST5V0M", imax=1431)
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_BAT_CHG"],
            "CPU" : ["+VDD_SYS_BUCKCPU"],
            "GPU" : ["+VDD_SYS_BUCKGPU"],
            "CORE" : ["+VDD_SYS_SD0"],
            "DRAM" : ["+VDD_SYS_SD1"],
            "APRAM" : ["+VDD_SYS_BUCKCPU", "+VDD_SYS_BUCKGPU", "+VDD_SYS_SD0", "+VDD_SYS_SD1"]
            }
