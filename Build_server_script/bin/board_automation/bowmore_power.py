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

class bowmore_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For Bowmore T124 (e1922), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
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

        self.pm_devs = {
            # total battery input/output
            "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.001, "VDD_BAT_CHG", imax=9000),
            # VDD_CPU buck-regulator input
            "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x42, 0.01, "VDD_SYS_BUCKCPU", imax=4197),
            # VDD_GPU buck-regulator input
            "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x43, 0.01, "VDD_SYS_BUCKGPU", imax=2798),
            # VDD_SOC buck-regulator input
            "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x48, 0.01, "VDD_SYS_BUCKSOC", imax=1399),
            # 1.35V buck-regulator input
            "VDD_5V0_SD2" : INA226(i2c_1, 0x49, 0.01, "VDD_5V0_SD2", imax=866),
            # modem's VDD_SYS input
            "VDD_WWAN_MDM" : INA226(i2c_1, 0x4B, 0.001, "VDD_WWAN_MDM", imax=2073),
            # backlight-regulator input
            "VDD_SYS_BL" : INA226(i2c_1, 0x4C, 0.03, "VDD_SYS_BL", imax=481),
            # Wi-Fi/Bluetooth VDD_SYS input
            "VDD_3V3A_COM" : INA226(i2c_1, 0x4E, 0.1, "VDD_3V3A_COM", imax=542)
            }
