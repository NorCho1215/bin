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

class atlantis_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For Atlantis (e1670), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
        # AUX2, and GEN2 I2C buses. The address for the PCA954x MUX is 010 which corresponds to the
        # 7-bit address 0x72.
        self.i2c = i2c
        pca = pca954x(i2c, 0x72)
        # PM_GEN2_0_I2C
        i2c_0 = pca954x_branch(pca, 0)
        # AUX_1_I2C
        i2c_1 = pca954x_branch(pca, 1)
        # AUX_2_I2C
        i2c_2 = pca954x_branch(pca, 2)

        print "Warning: Configuration only works for Atlantis E1670-A02 and newer boards"

        if variant and variant.upper() in ['DAQ']:
            # DAQ reworked Atlantis
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c_1, 0x40, 0.1, "VDD_SYS_CELL", imax=512),
                "VDD_RTC_LDO5" : INA226(i2c_1, 0x41, 0.5, "VDD_RTC_LDO5", imax=102),
                "VDD_SYS_SMPS1_2" : INA226(i2c_1, 0x42, 0.01, "VDD_SYS_SMPS1_2", imax=512),
                "VDD_SOC" : INA226(i2c_1, 0x43, 0.01, "VDD_SOC", imax=5120),
                "VDD_SYS_REG" : INA226(i2c_1, 0x44, 0.005, "VDD_SYS_REG", imax=1024),
                "VDD_CPU" : INA226(i2c_1, 0x45, 0.01, "VDD_CPU", imax=5120),
                "VDD_SYS_SMPS9" : INA226(i2c_1, 0x46, 0.1, "VDD_SYS_SMPS9", imax=51),
                "VDD_1V8_SMPS9" : INA226(i2c_1, 0x47, 0.01, "VDD_1V8_SMPS9", imax=512),
                "VDD_1V8_AP" : INA226(i2c_1, 0x48, 0.1, "VDD_1V8_AP", imax=171),
                "VDD_SYS_SMPS8" : INA226(i2c_1, 0x49, 0.1, "VDD_SYS_SMPS8", imax=51),
                "VDD_1V2_SMPS8" : INA226(i2c_1, 0x4B, 0.001, "VDD_1V2_SMPS8", imax=5120),
                "VDD_SW_1V2_MUX" : INA226(i2c_1, 0x4C, 0.1, "VDD_SW_1V2_MUX", imax=5120),
                "VDD_SW_1V2_DSI_CSI_AP" : INA226(i2c_1, 0x4E, 0.2, "VDD_SW_1V2_DSI_CSI_AP", imax=26),
                "AVDD_1V05_LDO4" : INA226(i2c_1, 0x4F, 0.03, "AVDD_1V05_LDO4", imax=171)
                }
        else:
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c_1, 0x40, 0.01, "VDD_SYS_CELL", imax=512),
                "VDD_RTC_LDO5" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO5", imax=102),
                "VDD_SYS_SMPS1_2" : INA226(i2c_1, 0x42, 0.01, "VDD_SYS_SMPS1_2", imax=512),
                "VDD_SOC" : INA226(i2c_1, 0x43, 0.001, "VDD_SOC", imax=5120),
                "VDD_SYS_REG" : INA226(i2c_1, 0x44, 0.005, "VDD_SYS_REG", imax=1024),
                "VDD_CPU" : INA226(i2c_1, 0x45, 0.001, "VDD_CPU", imax=5120),
                "VDD_SYS_SMPS9" : INA226(i2c_1, 0x46, 0.1, "VDD_SYS_SMPS9", imax=51),
                "VDD_1V8_SMPS9" : INA226(i2c_1, 0x47, 0.01, "VDD_1V8_SMPS9", imax=512),
                "VDD_1V8_AP" : INA226(i2c_1, 0x48, 0.03, "VDD_1V8_AP", imax=171),
                "VDD_SYS_SMPS8" : INA226(i2c_1, 0x49, 0.1, "VDD_SYS_SMPS8", imax=51),
                "VDD_1V2_SMPS8" : INA226(i2c_1, 0x4B, 0.001, "VDD_1V2_SMPS8", imax=5120),
                "VDD_SW_1V2_MUX" : INA226(i2c_1, 0x4C, 0.001, "VDD_SW_1V2_MUX", imax=5120),
                "VDD_SW_1V2_DSI_CSI_AP" : INA226(i2c_1, 0x4E, 0.2, "VDD_SW_1V2_DSI_CSI_AP", imax=26),
                "AVDD_1V05_LDO4" : INA226(i2c_1, 0x4F, 0.03, "AVDD_1V05_LDO4", imax=171)
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_SYS_CELL"],
            "CPU" : ["+VDD_CPU"],
            "CORE" : ["+VDD_SOC"]
            }

        if calibration!="min":
            self.pm_devs["VDD_SYS_CELL"].set_imax(6000)
            self.pm_devs["VDD_SYS_SMPS1_2"].set_imax(2800)
            self.pm_devs["VDD_SOC"].set_imax(8000)
            self.pm_devs["VDD_SYS_REG"].set_imax(4200)
            self.pm_devs["VDD_CPU"].set_imax(12000)
            self.pm_devs["VDD_SYS_SMPS9"].set_imax(385)
            self.pm_devs["VDD_1V8_SMPS9"].set_imax(667)
            self.pm_devs["VDD_1V8_AP"].set_imax(187)
            self.pm_devs["VDD_SYS_SMPS8"].set_imax(582)

        return
