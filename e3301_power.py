# Copyright (c) 2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina226 import INA226
from power import power
from pca954x import pca954x, pca954x_branch

class e3301_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For e3301/p2598 (T18x ERS), the buses off the PCA954x MUX which contain INA226 devices are AUX1,
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

        # T18x ERS (e3301/p2598)
        self.pm_devs = {
            # VDD_CVM_C2
            "VDD_CVM_C2" : INA226(i2c_1, 0x44, 0.001, "VDD_CVM_C2", imax=5000),
            # SYS_3V8_C1
            "SYS_3V8_C1" : INA226(i2c_1, 0x45, 0.001, "SYS_3V8_C1", imax=18000),
            # SYS_3V8_C2
            "SYS_3V8_C2" : INA226(i2c_1, 0x46, 0.001, "SYS_3V8_C2", imax=16000),
            # VDD_CVM_C1
            "VDD_CVM_C1" : INA226(i2c_1, 0x47, 0.001, "VDD_CVM_C1", imax=5000),
            # VDD_SYS_3V3_AO
            "VDD_SYS_3V3_AO" : INA226(i2c_1, 0x48, 0.01, "VDD_SYS_3V3_AO", imax=600),
            # VDD_3V3_ENET
            "VDD_3V3_ENET" : INA226(i2c_1, 0x49, 0.001, "VDD_3V3_ENET", imax=1000),
            # VDD_3V3_EMMC_CORE
            "VDD_3V3_EMMC_CORE" : INA226(i2c_1, 0x4A, 0.05, "VDD_3V3_EMMC_CORE", imax=400),
            # VDD_SYS_5V0_REG
            "VDD_SYS_5V0_REG" : INA226(i2c_1, 0x4B, 0.001, "VDD_SYS_5V0_REG", imax=3000),
            # VDD_CVM_MAIN
            "VDD_CVM_MAIN" : INA226(i2c_1, 0x4D, 0.001, "VDD_CVM_MAIN", imax=11200),
            # SOC_REG
            "SOC_REG" : INA226(i2c_2, 0x47, 0.001, "SOC_REG", imax=6000),
            # PMIC_SD0
            "PMIC_SD0" : INA226(i2c_2, 0x48, 0.001, "PMIC_SD0", imax=2122),
            # CPU_REG
            "CPU_REG" : INA226(i2c_2, 0x49, 0.001, "CPU_REG", imax=10000),
            # SRAM_REG
            "SRAM_REG" : INA226(i2c_2, 0x4A, 0.001, "SRAM_REG", imax=6000),
            # GPU_REG
            "GPU_REG" : INA226(i2c_2, 0x4B, 0.001, "GPU_REG", imax=10000),
            # VDD_1V8_EMMC_IO
            "VDD_1V8_EMMC_IO" : INA226(i2c_2, 0x4D, 0.1, "VDD_1V8_EMMC_IO", imax=450),
            # VDD_1V05_PEX_AP
            "VDD_1V05_PEX_AP" : INA226(i2c_2, 0x4E, 0.01, "VDD_1V05_PEX_AP", imax=104),
            # PMIC_LDO6_OUT
            "PMIC_LDO6_OUT" : INA226(i2c_2, 0x4F, 0.05, "PMIC_LDO6_OUT", imax=150),
            # VDD_SOC
            "VDD_SOC" : INA226(i2c_3, 0x44, 0.001, "VDD_SOC", imax=15000),
            # VDD_1V8_SD2_OUT_LSW
            "VDD_1V8_SD2_OUT_LSW" : INA226(i2c_3, 0x45, 0.001, "VDD_1V8_SD2_OUT_LSW", imax=2000),
            # VDD_SRAM
            "VDD_SRAM" : INA226(i2c_3, 0x46, 0.001, "VDD_SRAM", imax=15000),
            # VDD_BCPU
            "VDD_BCPU" : INA226(i2c_3, 0x47, 0.001, "VDD_BCPU", imax=12300),
            # VDD_VCLAMP_USB_AP
            "VDD_VCLAMP_USB_AP" : INA226(i2c_3, 0x48, 0.1, "VDD_VCLAMP_USB_AP", imax=125),
            # VDD_1V8_HDMI_DP_PLL_AP
            "VDD_1V8_HDMI_DP_PLL_AP" : INA226(i2c_3, 0x49, 0.05, "VDD_1V8_HDMI_DP_PLL_AP", imax=191),
            # VDD_1V8_SD2_OUT_DDR
            "VDD_1V8_SD2_OUT_DDR" : INA226(i2c_3, 0x4A, 0.01, "VDD_1V8_SD2_OUT_DDR", imax=2000),
            # VDD_RTC_AP
            "VDD_RTC_AP" : INA226(i2c_3, 0x4B, 0.1, "VDD_RTC_AP", imax=130),
            # VDD_1V1_SD0_OUT
            "VDD_1V1_SD0_OUT" : INA226(i2c_3, 0x4D, 0.001, "VDD_1V1_SD0_OUT", imax=8000),
            # VDD_GPU
            "VDD_GPU" : INA226(i2c_3, 0x4E, 0.001, "VDD_GPU", imax=26000),
            # VDD_MCPU
            "VDD_MCPU" : INA226(i2c_3, 0x4F, 0.001, "VDD_MCPU", imax=13500)
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_CVM_MAIN"],
            "CPU" : ["+CPU_REG"],
            "GPU" : ["+GPU_REG"],
            "CORE" : ["+SOC_REG"],
            "DRAM" : ["+VDD_1V8_SD2_OUT_DDR"],
            "APRAM" : ["+CPU_REG", "+GPU_REG", "+SOC_REG", "+VDD_1V8_SD2_OUT_DDR", "+SRAM_REG"]
            }
