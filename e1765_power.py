# Copyright (c) 2014, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina226 import INA226
from power import power
from pca954x import pca954x, pca954x_branch

class e1765_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For e1765 (Bowmore T132), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
        # AUX2, and AUX3 I2C buses. The address for the PCA954x MUX is 010 which corresponds to the
        # 7-bit address 0x72.
        self.i2c = i2c
        pca = pca954x(i2c, 0x72)
        # AUX_1_I2C
        i2c_1 = pca954x_branch(pca, 1)
        # AUX_2_I2C
        i2c_2 = pca954x_branch(pca, 2)
        # AUX_3_I2C
        i2c_3 = pca954x_branch(pca, 3)

        if variant and variant.upper() in ['DAQ']:
            # DAQ Reworked TN8 E1765
            self.pm_devs = {
                # total battery output
                "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.01, "VDD_BAT_CHG", imax=9000),
                # VDD CPU
                "VDD_SYS_SMPS1_2_3" : INA226(i2c_1, 0x42, 0.001, "VDD_SYS_SMPS1_2_3", imax=4197),
                # VDD_GPU
                "VDD_SYS_SMPS4_5" : INA226(i2c_1, 0x43, 0.001, "VDD_SYS_SMPS4_5", imax=2798),
                # VDD_SOC
                "VDD_SYS_SMPS7" : INA226(i2c_1, 0x48, 0.01, "VDD_SYS_SMPS7", imax=1399),
                # VDD_1V35
                "VDD_SYS_SMPS6" : INA226(i2c_1, 0x49, 0.01, "VDD_SYS_SMPS6", imax=866),
                # VDD_SYS_MDM
                "VDD_SYS_MDM" : INA226(i2c_1, 0x4B, 0.001, "VDD_SYS_MDM", imax=2073),
                # VDD_SYS_BOOST Backlight
                "VDD_SYS_BOOSTBL" : INA226(i2c_1, 0x4C, 0.03, "VDD_SYS_BOOSTBL", imax=481),
                # VDD_SYS_COM
                "VDD_SYS_COM" : INA226(i2c_1, 0x4E, 0.03, "VDD_SYS_COM", imax=542)
                }
        else:
            # TN8 FFD E1765
            self.pm_devs = {
                # total battery output
                "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.001, "VDD_BAT_CHG", imax=9000),
                # VDD CPU
                "VDD_SYS_SMPS1_2_3" : INA226(i2c_1, 0x42, 0.001, "VDD_SYS_SMPS1_2_3", imax=4197),
                # VDD_GPU
                "VDD_SYS_SMPS4_5" : INA226(i2c_1, 0x43, 0.001, "VDD_SYS_SMPS4_5", imax=2798),
                # VDD_SOC
                "VDD_SYS_SMPS7" : INA226(i2c_1, 0x48, 0.01, "VDD_SYS_SMPS7", imax=1399),
                # VDD_1V35
                "VDD_SYS_SMPS6" : INA226(i2c_1, 0x49, 0.01, "VDD_SYS_SMPS6", imax=866),
                # VDD_SYS_MDM
                "VDD_SYS_MDM" : INA226(i2c_1, 0x4B, 0.001, "VDD_SYS_MDM", imax=2073),
                # VDD_SYS_BOOST Backlight
                "VDD_SYS_BOOSTBL" : INA226(i2c_1, 0x4C, 0.03, "VDD_SYS_BOOSTBL", imax=481),
                # VDD_SYS_COM
                "VDD_SYS_COM" : INA226(i2c_1, 0x4E, 0.03, "VDD_SYS_COM", imax=542)
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_BAT_CHG"],
            "CPU" : ["+VDD_SYS_SMPS1_2_3"],
            "GPU" : ["+VDD_SYS_SMPS4_5"],
            "CORE" : ["+VDD_SYS_SMPS7"],
            "DRAM" : ["+VDD_SYS_SMPS6"],
            "APRAM" : ["+VDD_SYS_SMPS1_2_3", "+VDD_SYS_SMPS4_5", "+VDD_SYS_SMPS7", "+VDD_SYS_SMPS6"]
            }
