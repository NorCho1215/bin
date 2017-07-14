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

class e1784_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        self.i2c = i2c
        pca = pca954x(i2c, 0x72)
        # PM_GEN2_0_I2C
        i2c_0 = pca954x_branch(pca, 0)
        # AUX_1_I2C
        i2c_1 = pca954x_branch(pca, 1)
        # AUX_2_I2C
        i2c_2 = pca954x_branch(pca, 2)
        # AUX_2_I2C
        i2c_3 = pca954x_branch(pca, 3)

        self.pm_devs = {
            # total battery input/output
            "VDD_BAT_CHG" : INA226(i2c_1, 0x41, 0.005, "VDD_BAT_CHG", imax=9000),
            # VDD_CPU buck-regulator input
            "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x42, 0.01, "VDD_SYS_BUCKCPU", imax=4197),
            # VDD_GPU buck-regulator input
            "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x43, 0.01, "VDD_SYS_BUCKGPU", imax=2798),
            # VDD_SOC buck-regulator input
            "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x48, 0.01, "VDD_SYS_BUCKSOC", imax=1399),
            # 1.35V buck-regulator input
            "VDD_5V0_SD2" : INA226(i2c_1, 0x49, 0.01, "VDD_5V0_SD2", imax=866),
            # modem's VDD_SYS input
            "VDD_WWAN_MDM" : INA226(i2c_1, 0x4B, 0.005, "VDD_WWAN_MDM", imax=2073),
            # backlight-regulator input
            "VDD_SYS_BL" : INA226(i2c_1, 0x4C, 0.03, "VDD_SYS_BL", imax=481),
            # Wi-Fi/Bluetooth VDD_SYS input
            "VDD_3V3A_COM" : INA226(i2c_1, 0x4E, 0.1, "VDD_3V3A_COM", imax=542),
            # AP's VDD_RTC input
            "VDD_RTC_LDO3" : INA226(i2c_2, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
            # (unused)
            # "VDD_3V3A_LDO1_6" : INA226(i2c_2, 0x42, 1, "VDD_3V3A_LDO1_6", imax=1),
            # AVDD_LCD regulator output to display
            "VDD_DIS_3V3_LCD" : INA226(i2c_2, 0x43, 0.01, "VDD_DIS_3V3_LCD", imax=183),
            # power-gated 1.8V to LCD display
            "VDD_LCD_1V8B_DIS" : INA226(i2c_2, 0x48, 0.1, "VDD_LCD_1V8B_DIS", imax=45),
            # VDD_GPU buck-regulator output
            "VDD_GPU_BUCKGPU" : INA226(i2c_3, 0x48, 0.001, "VDD_GPU_BUCKGPU", imax=8000),
            # VDD_SOC buck-regulator output
            "VDD_SOC_SD1" : INA226(i2c_3, 0x49, 0.001, "VDD_SOC_SD1", imax=4000),
            # VDD_CPU buck-regulator output
            "VDD_CPU_BUCKCPU" : INA226(i2c_3, 0x4B, 0.001, "VDD_CPU_BUCKCPU", imax=12000),
            # 1.8V buck-regulator output
            "VDD_1V8_SD5" : INA226(i2c_3, 0x4C, 0.003, "VDD_1V8_SD5", imax=510),
            # "AP's 1.05V PLL
            "VDD_1V05_LDO0" : INA226(i2c_3, 0x4E, 0.03, "VDD_1V05_LDO0", imax=158)
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_BAT_CHG"],
            "CPU" : ["+VDD_CPU_BUCKCPU"],
            "GPU" : ["+VDD_GPU_BUCKGPU"],
            "CORE" : ["+VDD_SOC_SD1"]
            }
