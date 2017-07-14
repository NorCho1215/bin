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

class e2581_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For e2581 (Loki FF-PB T210), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
        # AUX2, and AUX3 I2C buses. The address for the PCA954x MUX is 001 which corresponds to the
        # 7-bit address 0x71.
        self.i2c = i2c
        pca = pca954x(i2c, 0x71)
        # AUX_1_I2C
        i2c_1 = pca954x_branch(pca, 1)
        # AUX_2_I2C
        i2c_2 = pca954x_branch(pca, 2)
        # AUX_3_I2C
        i2c_3 = pca954x_branch(pca, 3)

        # Loki FF-PB (e2581)
        self.pm_devs = {
            # total battery output
            "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.005, "VDD_BAT_CHG", imax=10000),
            # CPU rail from e2174
            "VDD_CPU_ISNS" : INA226(i2c_1, 0x42, 0.005, "VDD_CPU_ISNS", imax=8000),
            # GPU rail from e2174
            "VDD_GPU_ISNS" : INA226(i2c_1, 0x43, 0.005, "VDD_GPU_ISNS", imax=8000),
            # SOC rail from e2174
            "VDD_SOC_ISNS" : INA226(i2c_1, 0x48, 0.005, "VDD_SOC_ISNS", imax=4000),
            # DDR rail from e2174
            "VDD_DDR_ISNS" : INA226(i2c_1, 0x49, 0.01, "VDD_DDR_ISNS", imax=1000),
            # MDM
            "VDD_SYS_MDM1" : INA226(i2c_1, 0x4b, 0.005, "VDD_SYS_MDM1", imax=2500),
            # Backlight
            "VDD_SYS_BL" : INA226(i2c_1, 0x4c, 0.05, "VDD_SYS_BL", imax=200),
            # COM
            "VDD_SYS_COM" : INA226(i2c_1, 0x4e, 0.01, "VDD_SYS_COM", imax=600)
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_BAT_CHG"],
            "CPU" : ["+VDD_CPU_ISNS"],
            "GPU" : ["+VDD_GPU_ISNS"],
            "CORE" : ["+VDD_SOC_ISNS"],
            "DRAM" : ["+VDD_DDR_ISNS"],
            "APRAM" : ["+VDD_CPU_ISNS", "+VDD_GPU_ISNS", "+VDD_SOC_ISNS", "+VDD_DDR_ISNS"]
            }
