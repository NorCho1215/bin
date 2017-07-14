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

class ardbeg_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For Ardbeg (e1780), the buses off the PCA954x MUX which contain INA226 devices are AUX1, 
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

        if variant and variant.upper() in ['DAQ']:
            # DAQ Reworked Ardbeg w/1735
            self.pm_devs = {
                # total battery output
                "VDD_SYS_BAT" : INA226(i2c_1, 0x40, 0.01, "VDD_SYS_BAT", imax=512),
                # AP's VDD_RTC input
                "VDD_RTC_LDO3" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
                # VDD_SOC buck-regulator input
                "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x42, 0.02, "VDD_SYS_BUCKSOC", imax=170.7),
                # VDD_SOC buck-regulator output
                "VDD_SOC_SD1" : INA226(i2c_1, 0x43, 0.01, "VDD_SOC_SD1", imax=4686),
                # VDD_CPU buck-regulator input
                "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x44, 0.01, "VDD_SYS_BUCKCPU", imax=512),
                # VDD_CPU buck-regulator output
                "VDD_CPU_BUCKCPU" : INA226(i2c_1, 0x45, 0.01, "VDD_CPU_BUCKCPU", imax=5120),
                # 1.8V buck-regulator output
                "VDD_1V8_SD5" : INA226(i2c_1, 0x46, 0.01, "VDD_1V8_SD5", imax=512),
                # VDD_CAM_1V8 & VDDIO_SDMMC3 regulator inputs
                "VDD_3V3A_LDO1_6" : INA226(i2c_1, 0x47, 1, "VDD_3V3A_LDO1_6", imax=25.6),
                # power-gated 3.3V to LCD display
                "VDD_DIS_3V3_LCD" : INA226(i2c_1, 0x48, 0.01, "VDD_DIS_3V3_LCD", imax=212),
                # 1.35V buck-regulator output
                "VDD_1V35_SD2" : INA226(i2c_1, 0x49, 0.01, "VDD_1V35_SD2", imax=2274),
                # VDD_GPU buck-regulator input
                "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x4B, 0.01, "VDD_SYS_BUCKGPU", imax=512),
                # power-gated 1.8V to LCD display
                "VDD_LCD_1V8B_DIS" : INA226(i2c_1, 0x4E, 0.1, "VDD_LCD_1V8B_DIS", imax=50),
                # AP's 1.05V PLL, DDR_HS, & LVDS inputs
                "VDD_1V05_LDO0" : INA226(i2c_1, 0x4F, 0.03, "VDD_1V05_LDO0", imax=130)
                }

        elif variant and variant.upper() in ['1733_DAQ']:
            # DAQ Reworked Ardbeg w/1733
            self.pm_devs = {
                # total battery output
                "VDD_SYS_BAT" : INA226(i2c_1, 0x40, 0.01, "VDD_SYS_BAT", imax=512),
                # AP's VDD_RTC input
                "VDD_RTC_LDO3" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
                # VDD_SOC buck-regulator input
                "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x42, 0.03, "VDD_SYS_BUCKSOC", imax=170.7),
                # VDD_SOC buck-regulator output
                "VDD_SOC_SD1" : INA226(i2c_1, 0x43, 0.01, "VDD_SOC_SD1", imax=4686),
                # VDD_CPU buck-regulator input
                "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x44, 0.01, "VDD_SYS_BUCKCPU", imax=512),
                # VDD_CPU buck-regulator output
                "VDD_CPU_BUCKCPU" : INA226(i2c_1, 0x45, 0.01, "VDD_CPU_BUCKCPU", imax=5120),
                # 1.8V buck-regulator output
                "VDD_1V8_SD5" : INA226(i2c_1, 0x46, 0.01, "VDD_1V8_SD5", imax=512),
                # VDD_CAM_1V8 & VDDIO_SDMMC3 regulator inputs
                "VDD_3V3A_LDO1_6" : INA226(i2c_1, 0x47, 0.2, "VDD_3V3A_LDO1_6", imax=25.6),
                # power-gated 3.3V to LCD display
                "VDD_DIS_3V3_LCD" : INA226(i2c_1, 0x48, 0.01, "VDD_DIS_3V3_LCD", imax=212),
                # 1.35V buck-regulator output
                "VDD_1V35_SD2" : INA226(i2c_1, 0x49, 0.01, "VDD_1V35_SD2", imax=2274),
                # VDD_GPU buck-regulator input
                "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x4B, 0.01, "VDD_SYS_BUCKGPU", imax=512),
                # power-gated 1.8V to LCD display
                "VDD_LCD_1V8B_DIS" : INA226(i2c_1, 0x4E, 0.1, "VDD_LCD_1V8B_DIS", imax=50),
                # AP's 1.05V PLL, DDR_HS, & LVDS inputs
                "VDD_1V05_LDO0" : INA226(i2c_1, 0x4F, 0.03, "VDD_1V05_LDO0", imax=130)
                }

        elif variant and variant.upper() in ['1733']:
            # Normal Ardbeg w/1733 PMIC
            self.pm_devs = {
                # total battery output
                "VDD_SYS_BAT" : INA226(i2c_1, 0x40, 0.01, "VDD_SYS_BAT", imax=512),
                # AP's VDD_RTC input
                "VDD_RTC_LDO3" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
                # VDD_SOC buck-regulator input
                "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x42, 0.03, "VDD_SYS_BUCKSOC", imax=170.7),
                # VDD_SOC buck-regulator output
                "VDD_SOC_SD1" : INA226(i2c_1, 0x43, 0.001, "VDD_SOC_SD1", imax=4686),
                # VDD_CPU buck-regulator input
                "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x44, 0.01, "VDD_SYS_BUCKCPU", imax=512),
                # VDD_CPU buck-regulator output
                "VDD_CPU_BUCKCPU" : INA226(i2c_1, 0x45, 0.001, "VDD_CPU_BUCKCPU", imax=5120),
                # 1.8V buck-regulator output
                "VDD_1V8_SD5" : INA226(i2c_1, 0x46, 0.01, "VDD_1V8_SD5", imax=512),
                # VDD_CAM_1V8 & VDDIO_SDMMC3 regulator inputs
                "VDD_3V3A_LDO1_6" : INA226(i2c_1, 0x47, 0.2, "VDD_3V3A_LDO1_6", imax=25.6),
                # power-gated 3.3V to LCD display
                "VDD_DIS_3V3_LCD" : INA226(i2c_1, 0x48, 0.01, "VDD_DIS_3V3_LCD", imax=212),
                # 1.35V buck-regulator output
                "VDD_1V35_SD2" : INA226(i2c_1, 0x49, 0.001, "VDD_1V35_SD2", imax=2274),
                # VDD_GPU buck-regulator input
                "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x4B, 0.01, "VDD_SYS_BUCKGPU", imax=512),
                # power-gated 1.8V to LCD display
                "VDD_LCD_1V8B_DIS" : INA226(i2c_1, 0x4E, 0.1, "VDD_LCD_1V8B_DIS", imax=50),
                # AP's 1.05V PLL, DDR_HS, & LVDS inputs
                "VDD_1V05_LDO0" : INA226(i2c_1, 0x4F, 0.03, "VDD_1V05_LDO0", imax=130)
                }
        elif variant and variant.upper() in ['TN8', 'E1736-A00_E1780-A02_TN8']:
            # TN8 A02 w/ E1736 PMIC
            self.pm_devs = {
                # total battery output
                "VDD_SYS_BAT" : INA226(i2c_1, 0x40, 0.003, "VDD_SYS_BAT", imax=4100),
                # AP's VDD_RTC input
                "VDD_RTC_LDO3" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
                # VDD_SOC buck-regulator input
                "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x42, 0.01, "VDD_SYS_BUCKSOC", imax=1399),
                # VDD_SOC buck-regulator output
                "VDD_SOC_SD1" : INA226(i2c_1, 0x43, 0.001, "VDD_SOC_SD1", imax=4000),
                # VDD_CPU buck-regulator input
                "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x44, 0.01, "VDD_SYS_BUCKCPU", imax=3148),
                # VDD_CPU buck-regulator output
                "VDD_CPU_BUCKCPU" : INA226(i2c_1, 0x45, 0.001, "VDD_CPU_BUCKCPU", imax=9000),
                # 1.8V buck-regulator output
                "VDD_1V8_SD5" : INA226(i2c_1, 0x46, 0.003, "VDD_1V8_SD5", imax=1069),
                # VDD_CAM_1V8 regulator input
                "VDD_3V3A_LDO1_6" : INA226(i2c_1, 0x47, 0.01, "VDD_3V3A_LDO1_6", imax=100),
                # power-gated 3.3V to LCD display
                "VDD_DIS_3V3_LCD" : INA226(i2c_1, 0x48, 0.01, "VDD_DIS_3V3_LCD", imax=117),
                # 1.35V buck-regulator output
                "VDD_1V35_SD2" : INA226(i2c_1, 0x49, 0.001, "VDD_1V35_SD2", imax=2237),
                # VDD_GPU buck-regulator input
                "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x4B, 0.01, "VDD_SYS_BUCKGPU", imax=2798),
                # power-gated 1.8V to LCD display
                "VDD_LCD_1V8B_DIS" : INA226(i2c_1, 0x4E, 0.1, "VDD_LCD_1V8B_DIS", imax=50),
                # AP's 1.05V PLL, DDR_HS, & LVDS inputs
                "VDD_1V05_LDO0" : INA226(i2c_1, 0x4F, 0.03, "VDD_1V05_LDO0", imax=130)
                }
        else:
            # Normal Ardbeg w/1735 PMIC
            self.pm_devs = {
                # total battery output
                "VDD_SYS_BAT" : INA226(i2c_1, 0x40, 0.01, "VDD_SYS_BAT", imax=512),
                # AP's VDD_RTC input
                "VDD_RTC_LDO3" : INA226(i2c_1, 0x41, 0.05, "VDD_RTC_LDO3", imax=86),
                # VDD_SOC buck-regulator input
                "VDD_SYS_BUCKSOC" : INA226(i2c_1, 0x42, 0.02, "VDD_SYS_BUCKSOC", imax=170.7),
                # VDD_SOC buck-regulator output
                "VDD_SOC_SD1" : INA226(i2c_1, 0x43, 0.001, "VDD_SOC_SD1", imax=4686),
                # VDD_CPU buck-regulator input
                "VDD_SYS_BUCKCPU" : INA226(i2c_1, 0x44, 0.01, "VDD_SYS_BUCKCPU", imax=512),
                # VDD_CPU buck-regulator output
                "VDD_CPU_BUCKCPU" : INA226(i2c_1, 0x45, 0.001, "VDD_CPU_BUCKCPU", imax=5120),
                # 1.8V buck-regulator output
                "VDD_1V8_SD5" : INA226(i2c_1, 0x46, 0.005, "VDD_1V8_SD5", imax=512),
                # VDD_CAM_1V8 & VDDIO_SDMMC3 regulator inputs
                "VDD_3V3A_LDO1_6" : INA226(i2c_1, 0x47, 1, "VDD_3V3A_LDO1_6", imax=25.6),
                # power-gated 3.3V to LCD display
                "VDD_DIS_3V3_LCD" : INA226(i2c_1, 0x48, 0.01, "VDD_DIS_3V3_LCD", imax=212),
                # 1.35V buck-regulator output
                "VDD_1V35_SD2" : INA226(i2c_1, 0x49, 0.001, "VDD_1V35_SD2", imax=2274),
                # VDD_GPU buck-regulator input
                "VDD_SYS_BUCKGPU" : INA226(i2c_1, 0x4B, 0.01, "VDD_SYS_BUCKGPU", imax=512),
                # power-gated 1.8V to LCD display
                "VDD_LCD_1V8B_DIS" : INA226(i2c_1, 0x4E, 0.1, "VDD_LCD_1V8B_DIS", imax=50),
                # AP's 1.05V PLL, DDR_HS, & LVDS inputs
                "VDD_1V05_LDO0" : INA226(i2c_1, 0x4F, 0.03, "VDD_1V05_LDO0", imax=130)
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_SYS_BAT"],
            "CPU" : ["+VDD_CPU_BUCKCPU"],
            "GPU" : ["+VDD_SYS_BUCKGPU"],
            "CORE" : ["+VDD_SOC_SD1"],
            "DRAM" : ["+VDD_1V35_SD2"],
            "APRAM" : ["+VDD_CPU_BUCKCPU", "+VDD_SYS_BUCKGPU", "+VDD_SOC_SD1", "+VDD_1V35_SD2"]
            }

        if calibration!="min":
                self.pm_devs["VDD_SYS_BAT"].set_imax(3378)
                self.pm_devs["VDD_SYS_BUCKSOC"].set_imax(819)
                self.pm_devs["VDD_SYS_BUCKCPU"].set_imax(2448)
                self.pm_devs["VDD_CPU_BUCKCPU"].set_imax(14000)
                self.pm_devs["VDD_1V8_SD5"].set_imax(937)
                self.pm_devs["VDD_3V3A_LDO1_6"].set_imax(56)
                self.pm_devs["VDD_SYS_BUCKGPU"].set_imax(2099)

