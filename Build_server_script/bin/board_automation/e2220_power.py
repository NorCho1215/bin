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

class e2220_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For e2220 (T210 DSC ERS), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
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

        # T210_DSC (e2220) with e2174 PMU
        self.pm_devs = {
            # total battery output
            "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.01, "VDD_BAT_CHG", imax=14662),
            # CPU rail from e2174
            "VDD_CPU_ISNS" : INA226(i2c_1, 0x42, 0.005, "VDD_CPU_ISNS", imax=6600),
            # GPU rail from e2174
            "VDD_GPU_ISNS" : INA226(i2c_1, 0x43, 0.005, "VDD_GPU_ISNS", imax=4500),
            # SOC rail from e2174
            "VDD_SOC_ISNS" : INA226(i2c_1, 0x48, 0.005, "VDD_SOC_ISNS", imax=1800),
            # DDR rail from e2174
            "VDD_DDR_ISNS" : INA226(i2c_1, 0x49, 0.005, "VDD_DDR_ISNS", imax=1600),
            # MDM
            "VDD_SYS_MDM1" : INA226(i2c_1, 0x4b, 0.001, "VDD_SYS_MDM1", imax=2073),
            # Backlight
            "VDD_SYS_BL" : INA226(i2c_1, 0x4c, 0.01, "VDD_SYS_BL", imax=2000),
            # COM
            "VDD_SYS_COM" : INA226(i2c_1, 0x4e, 0.1, "VDD_SYS_COM", imax=102),
            # AP's VDD_RTC input
            "VDD_RTC_AP" : INA226(i2c_2, 0x41, 0.1, "VDD_RTC_AP", imax=50),
            # GEN_PLL_EDP_1V05
            "VDD_GEN_PLL_EDP_1V05" : INA226(i2c_2, 0x42, 0.05, "VDD_GEN_PLL_EDP_1V05", imax=450),
            # VDD_DIS_3V3_LCD
            "VDD_DIS_3V3_LCD" : INA226(i2c_2, 0x43, 0.01, "VDD_DIS_3V3_LCD", imax=280),
            # power-gated 1.8V to LCD display
            "VDD_LCD_1V8_DIS" : INA226(i2c_2, 0x48, 0.1, "VDD_LCD_1V8_DIS", imax=50),
            # AP's DDRIO & LPDDR3 inputs
            "VDD_DDR" : INA226(i2c_3, 0x45, 0.001, "VDD_DDR", imax=1698),
            # VDD_GPU buck-regulator output
            "VDD_GPU_AP" : INA226(i2c_3, 0x48, 0.001, "VDD_GPU_AP", imax=20000),
            # VDD_SOC buck-regulator output
            "VDD_SOC_AP" : INA226(i2c_3, 0x49, 0.001, "VDD_SOC_AP", imax=6000),
            # VDD_CPU buck-regulator output
            "VDD_CPU_AP" : INA226(i2c_3, 0x4B, 0.001, "VDD_CPU_AP", imax=20000),
            # 1.8V buck-regulator output
            "VDD_PMU_1V8" : INA226(i2c_3, 0x4C, 0.005, "VDD_PMU_1V8", imax=2000),
            # AP's 1.05V PLLs inputs
            "AVDD_1V05_GEN_PLL" : INA226(i2c_3, 0x4E, 0.03, "AVDD_1V05_GEN_PLL", imax=101)
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_BAT_CHG"],
            "CPU" : ["+VDD_CPU_ISNS"],
            "GPU" : ["+VDD_GPU_ISNS"],
            "CORE" : ["+VDD_SOC_ISNS"],
            "DRAM" : ["+VDD_DDR_ISNS"],
            "APRAM" : ["+VDD_CPU_ISNS", "+VDD_GPU_ISNS", "+VDD_SOC_ISNS", "+VDD_DDR_ISNS"]
            }
