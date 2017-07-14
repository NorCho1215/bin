# Copyright (c) 2013-2014, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina226 import INA226
from power import power
from pca954x import pca954x, pca954x_branch

class pluto_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For Pluto (e1580), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
        # AUX2, and GEN2 I2C buses. The address for the PCA954x MUX is 010 which corresponds to the
        # 7-bit address 0x72.
        self.i2c = i2c
        pca = pca954x(i2c, 0x72)
        # GEN2_0_I2C
        i2c_0 = pca954x_branch(pca, 0)
        # AUX_1_I2C
        i2c_1 = pca954x_branch(pca, 1)
        # AUX_2_I2C
        i2c_2 = pca954x_branch(pca, 2)

        if variant and variant.upper() in ['DAQ']:
            # DAQ reworked Pluto
            self.pm_devs = {
                "VDD_SYS_SUM" : INA226(i2c_1, 0x40, 0.1, "VDD_SYS_SUM", imax=1600),
                "VDD_SYS_SMPS123" : INA226(i2c_1, 0x41, 0.05, "VDD_SYS_SMPS123", imax=1024),
                "VDD_SYS_SMPS45" : INA226(i2c_1, 0x42, 0.05, "VDD_SYS_SMPS45", imax=1024),
                "VDD_SYS_SMPS6" :  INA226(i2c_1, 0x43, 0.05, "VDD_SYS_SMPS6", imax=300),
                "VDD_SYS_SMPS7" : INA226(i2c_1, 0x44, 0.5, "VDD_SYS_SMPS7", imax=155),
                "VDD_SYS_SMPS8" : INA226(i2c_1, 0x45, 0.1, "VDD_SYS_SMPS8", imax=300),
                "VDD_SYS_BL" : INA226(i2c_1, 0x46, 0.05, "VDD_SYS_BL", imax=200),
                "VDD_SYS_LDO08" : INA226(i2c_1, 0x47, 0.5, "VDD_SYS_LDO08", imax=52),
                "VDD_MMC_LDO9" : INA226(i2c_1, 0x48, 0.5, "VDD_MMC_LDO9", imax=40),
                "VDD_5V0_LDOUSB" : INA226(i2c_1, 0x49, 0.2, "VDD_5V0_LDOUSB", imax=70),
                "VDD_1V8_AP" : INA226(i2c_1, 0x4b, 0.05, "VDD_1V8_AP", imax=165),
                "VDD_MMC_LCD" : INA226(i2c_1, 0x4c, 0.2, "VDD_MMC_LCD", imax=60),
                "VDDIO_HSIC_BB" : INA226(i2c_1, 0x4e, 0.5, "VDDIO_HSIC_BB", imax=12),
                "AVDD_PLL_BB" : INA226(i2c_1, 0x4f, 0.5, "AVDD_PLL_BB", imax=10),
                }

        else:
            # "normal" Pluto
            self.pm_devs = {
                "VDD_SYS_SUM" : INA226(i2c_1, 0x40, 0.003, "VDD_SYS_SUM", imax=1600),
                "VDD_SYS_SMPS123" : INA226(i2c_1, 0x41, 0.005, "VDD_SYS_SMPS123", imax=1024),
                "VDD_SYS_SMPS45" : INA226(i2c_1, 0x42, 0.005, "VDD_SYS_SMPS45", imax=1024),
                "VDD_SYS_SMPS6" :  INA226(i2c_1, 0x43, 0.03, "VDD_SYS_SMPS6", imax=300),
                "VDD_SYS_SMPS7" : INA226(i2c_1, 0x44, 0.05, "VDD_SYS_SMPS7", imax=155),
                "VDD_SYS_SMPS8" : INA226(i2c_1, 0x45, 0.05, "VDD_SYS_SMPS8", imax=300),
                "VDD_SYS_BL" : INA226(i2c_1, 0x46, 0.05, "VDD_SYS_BL", imax=200),
                "VDD_SYS_LDO08" : INA226(i2c_1, 0x47, 0.2, "VDD_SYS_LDO08", imax=52),
                "VDD_MMC_LDO9" : INA226(i2c_1, 0x48, 0.2, "VDD_MMC_LDO9", imax=40),
                "VDD_5V0_LDOUSB" : INA226(i2c_1, 0x49, 0.2, "VDD_5V0_LDOUSB", imax=70),
                "VDD_1V8_AP" : INA226(i2c_1, 0x4b, 0.05, "VDD_1V8_AP", imax=165),
                "VDD_MMC_LCD" : INA226(i2c_1, 0x4c, 0.2, "VDD_MMC_LCD", imax=60),
                "VDDIO_HSIC_BB" : INA226(i2c_1, 0x4e, 0.5, "VDDIO_HSIC_BB", imax=12),
                "AVDD_PLL_BB" : INA226(i2c_1, 0x4f, 0.5, "AVDD_PLL_BB", imax=10)
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_SYS_SUM"],
            "Backlight" : ["+VDD_SYS_BL"],
            "Display_Subsystem" : ["+VDD_SYS_BL", "+VDD_MMC_LCD"],
            "DRAM" : ["+VDD_SYS_SMPS7"],
            "CPU" : ["+VDD_SYS_SMPS123"],
            "CORE" : ["+VDD_SYS_SMPS45"],
            "APRAM" : ["+VDD_SYS_SMPS7", "+VDD_SYS_SMPS123", "+VDD_SYS_SMPS45"],
            "All_Rails" : ['+'+x for x in self.pm_devs.keys()]
            }

        if calibration!="min":
            self.pm_devs["VDD_SYS_SUM"].set_imax(4000)
            self.pm_devs["VDD_SYS_SMPS123"].set_imax(3000)
            self.pm_devs["VDD_SYS_SMPS45"].set_imax(2000)
            self.pm_devs["VDD_SYS_SMPS7"].set_imax(300)
            self.pm_devs["VDD_SYS_BL"].set_imax(600)
            self.pm_devs["VDD_SYS_LDO08"].set_imax(72)

        return
