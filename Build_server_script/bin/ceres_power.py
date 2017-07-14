# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina226 import INA226
from power import power

class ceres_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For ceres, we need to select the proper I2C bus through the mux, Phillips PCA 9546.  We are
        # selecting AUX Bus 1 on the main board which internally to the phillips chip is channel 1.
        # Ceres has the phillips chip as address 010 so 7-bit address would be 72h.
        i2c.send_bytes(0x72, [0, 2]);

        if variant and variant.upper() in ['A01', 'A02']:
            # A02 Ceres
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c, 0x40, 0.01, "TOTAL", imax=6000),
                "VDD_SYS_BUCK3" : INA226(i2c, 0x41, 0.1, "VDD_SYS_BUCK3", imax=450),
                "VDD_SYS_BUCK2" : INA226(i2c, 0x42, 0.005, "VDD_SYS_BUCK2", imax=2238),
                "VDD_SOC" :  INA226(i2c, 0x43, 0.001, "VDD_SOC", imax=6400),
                "VDD_SYS_REG" : INA226(i2c, 0x44, 0.005, "VDD_SYS_REG", imax=4197),
                "VDD_CPU_AP" : INA226(i2c, 0x45, 0.001, "VDD_CPU_AP", imax=12000),
                "VDD_SW_1V2_DSI_CSI" : INA226(i2c, 0x46, 0.2, "VDD_SW_1V2_DSI_CSI", imax=35),
                "VDD_1V8_BUCK5" : INA226(i2c, 0x47, 0.01, "VDD_1V8_BUCK5", imax=757)
                }

        elif variant and variant.upper() in ['FFD_DAQ']:
            # Normal FFD daq reworked Ceres
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c, 0x40, 0.1, "TOTAL", imax=6000),
                "VDD_RTC_AP" : INA226(i2c, 0x41, 0.5, "VDD_RTC_AP", imax=77),
                "VDD_SYS_BUCK1" : INA226(i2c, 0x42, 0.01, "VDD_SYS_BUCK1", imax=1049),
                "VDD_SOC" : INA226(i2c, 0x43, 0.01, "VDD_SOC", imax=3000),
                "VDD_SYS_BUCK2" : INA226(i2c, 0x44, 0.005, "VDD_SYS_BUCK2", imax=2238),
                "VDD_CPU_AP" : INA226(i2c, 0x45, 0.01, "VDD_CPU_AP", imax=6400),
                "VDD_SYS_BUCK5" : INA226(i2c, 0x46, 0.1, "VDD_SYS_BUCK5", imax=433),
                "VDD_1V8_BUCK5" : INA226(i2c, 0x47, 0.01, "VDD_1V8_BUCK5", imax=757),
                "VDD_1V8_AP" : INA226(i2c, 0x48, 0.1, "VDD_1V8_AP", imax=187),
                "VDD_SYS_BUCK3" : INA226(i2c, 0x49, 0.1, "VDD_SYS_BUCK3", imax=450),
                "VDD_1V2_BUCK3" : INA226(i2c, 0x4b, 0.001, "VDD_1V2_BUCK3", imax=1179),
                "VDD_SW_1V2_MUX" : INA226(i2c, 0x4c, 0.001, "VDD_SW_1V2_MUX", imax=663),
                "VDD_SW_1V2_DSI_CSI" : INA226(i2c, 0x4e, 0.2, "VDD_SW_1V2_DSI_CSI", imax=35),
                "AVDD_1V05_LDO7" : INA226(i2c, 0x4f, 0.03, "AVDD_1V05_LDO7", imax=119)
                }

        elif variant and variant.upper() in ['DAQ']:
            # Normal daq reworked Ceres
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c, 0x40, 0.1, "TOTAL", imax=6000),
                "VDD_RTC_AP" : INA226(i2c, 0x41, 0.5, "VDD_RTC_AP", imax=77),
                "VDD_SYS_BUCK2" : INA226(i2c, 0x42, 0.005, "VDD_SYS_BUCK2", imax=2238),
                "VDD_SOC" : INA226(i2c, 0x43, 0.01, "VDD_SOC", imax=6400),
                "VDD_SYS_REG" : INA226(i2c, 0x44, 0.005, "VDD_SYS_REG", imax=4197),
                "VDD_CPU_AP" : INA226(i2c, 0x45, 0.01, "VDD_CPU_AP", imax=12000),
                "VDD_SYS_BUCK5" : INA226(i2c, 0x46, 0.1, "VDD_SYS_BUCK5", imax=433),
                "VDD_1V8_BUCK5" : INA226(i2c, 0x47, 0.01, "VDD_1V8_BUCK5", imax=757),
                "VDD_1V8_AP" : INA226(i2c, 0x48, 0.1, "VDD_1V8_AP", imax=187),
                "VDD_SYS_BUCK3" : INA226(i2c, 0x49, 0.1, "VDD_SYS_BUCK3", imax=450),
                "VDD_1V2_BUCK3" : INA226(i2c, 0x4b, 0.001, "VDD_1V2_BUCK3", imax=1179),
                "VDD_SW_1V2_MUX" : INA226(i2c, 0x4c, 0.001, "VDD_SW_1V2_MUX", imax=663),
                "VDD_SW_1V2_DSI_CSI" : INA226(i2c, 0x4e, 0.2, "VDD_SW_1V2_DSI_CSI", imax=35),
                "AVDD_1V05_LDO7" : INA226(i2c, 0x4f, 0.03, "AVDD_1V05_LDO7", imax=119)
                }

        elif variant and variant.upper() in ['FFD']:
            # Normal FFD Ceres
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c, 0x40, 0.01, "TOTAL", imax=6000),
                "VDD_RTC_AP" : INA226(i2c, 0x41, 0.02, "VDD_RTC_AP", imax=77),
                "VDD_SYS_BUCK1" : INA226(i2c, 0x42, 0.01, "VDD_SYS_BUCK1", imax=1049),
                "VDD_SOC" : INA226(i2c, 0x43, 0.001, "VDD_SOC", imax=3000),
                "VDD_SYS_BUCK2" : INA226(i2c, 0x44, 0.005, "VDD_SYS_BUCK2", imax=2238),
                "VDD_CPU_AP" : INA226(i2c, 0x45, 0.001, "VDD_CPU_AP", imax=6400),
                "VDD_SYS_BUCK5" : INA226(i2c, 0x46, 0.1, "VDD_SYS_BUCK5", imax=433),
                "VDD_1V8_BUCK5" : INA226(i2c, 0x47, 0.01, "VDD_1V8_BUCK5", imax=757),
                "VDD_1V8_AP" : INA226(i2c, 0x48, 0.03, "VDD_1V8_AP", imax=187),
                "VDD_SYS_BUCK3" : INA226(i2c, 0x49, 0.1, "VDD_SYS_BUCK3", imax=450),
                "VDD_1V2_BUCK3" : INA226(i2c, 0x4b, 0.001, "VDD_1V2_BUCK3", imax=1179),
                "VDD_SW_1V2_MUX" : INA226(i2c, 0x4c, 0.001, "VDD_SW_1V2_MUX", imax=663),
                "VDD_SW_1V2_DSI_CSI" : INA226(i2c, 0x4e, 0.2, "VDD_SW_1V2_DSI_CSI", imax=35),
                "AVDD_1V05_LDO7" : INA226(i2c, 0x4f, 0.03, "AVDD_1V05_LDO7", imax=119)
                }
        else:
            # Normal Ceres
            self.pm_devs = {
                "VDD_SYS_CELL" : INA226(i2c, 0x40, 0.01, "TOTAL", imax=6000),
                "VDD_RTC_AP" : INA226(i2c, 0x41, 0.02, "VDD_RTC_AP", imax=77),
                "VDD_SYS_BUCK2" : INA226(i2c, 0x42, 0.005, "VDD_SYS_BUCK2", imax=2238),
                "VDD_SOC" : INA226(i2c, 0x43, 0.001, "VDD_SOC", imax=6400),
                "VDD_SYS_REG" : INA226(i2c, 0x44, 0.005, "VDD_SYS_REG", imax=4197),
                "VDD_CPU_AP" : INA226(i2c, 0x45, 0.001, "VDD_CPU_AP", imax=12000),
                "VDD_SYS_BUCK5" : INA226(i2c, 0x46, 0.1, "VDD_SYS_BUCK5", imax=433),
                "VDD_1V8_BUCK5" : INA226(i2c, 0x47, 0.01, "VDD_1V8_BUCK5", imax=757),
                "VDD_1V8_AP" : INA226(i2c, 0x48, 0.03, "VDD_1V8_AP", imax=187),
                "VDD_SYS_BUCK3" : INA226(i2c, 0x49, 0.1, "VDD_SYS_BUCK3", imax=450),
                "VDD_1V2_BUCK3" : INA226(i2c, 0x4b, 0.001, "VDD_1V2_BUCK3", imax=1179),
                "VDD_SW_1V2_MUX" : INA226(i2c, 0x4c, 0.001, "VDD_SW_1V2_MUX", imax=663),
                "VDD_SW_1V2_DSI_CSI" : INA226(i2c, 0x4e, 0.2, "VDD_SW_1V2_DSI_CSI", imax=35),
                "AVDD_1V05_LDO7" : INA226(i2c, 0x4f, 0.03, "AVDD_1V05_LDO7", imax=119)
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_SYS_CELL"],
            "CPU" : ["+VDD_CPU_AP"],
            "CORE" : ["+VDD_SOC"]
            }
