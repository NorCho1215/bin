# Copyright (c) 2015, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina3221 import INA3221
from power import power

class p3310_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # For p3310 (Jetson T18x), the debug bus from PM342 is hardwired to i2c_gp1.
        self.i2c = i2c

        # Jetson T18x (p3310/p2597)
        self.pm_devs = {
            # GPU rail
            "GPU_INA" : INA3221(i2c, 0x40, 1, 0.005, "GPU_INA"),
            # SOC rail
            "SOC_INA" : INA3221(i2c, 0x40, 2, 0.005, "SOC_INA"),
            # WIFI rail
            "WIFI_INA" : INA3221(i2c, 0x40, 3, 0.01, "WIFI_INA"),
            # VDD 5V0 SYS
            "VDD_IN_SENSE" : INA3221(i2c, 0x41, 1, 0.001, "VDD_IN_SENSE"),
            # CPU Rail
            "CPU_INA" : INA3221(i2c, 0x41, 2, 0.005, "CPU_INA"),
            # SRAM rail
            "SRAM_INA" : INA3221(i2c, 0x41, 3, 0.005, "SRAM_INA"),
            # VDD MUX
            "VDD_MUX" : INA3221(i2c, 0x42, 1, 0.02, "VDD_MUX"),
            # VDD 5V IO SYS
            "VDD_5V_IO_SYS" : INA3221(i2c, 0x42, 2, 0.005, "VDD_5V_IO_SYS"),
            # VDD 3V3 SYS
            "VDD_3V3_SYS" : INA3221(i2c, 0x42, 3, 0.01, "VDD_3V3_SYS"),
            # VDD 3V3 IO SLP
            "VDD_3V3_IO_SLP" : INA3221(i2c, 0x43, 1, 0.01, "VDD_3V3_IO_SLP"),
            # VDD 1V8 IO
            "VDD_1V8_IO" : INA3221(i2c, 0x43, 2, 0.01, "VDD_1V8_IO"),
            # VDD M2 IN
            "VDD_M2_IN" : INA3221(i2c, 0x43, 3, 0.01, "VDD_M2_IN")
            }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_IN_SENSE"],
            "CPU" : ["+CPU_INA"],
            "GPU" : ["+GPU_INA"],
            "CORE" : ["+SOC_INA"],
            "DRAM" : ["+VDD_1V8_IO"],
            "APRAM" : ["+CPU_INA", "+GPU_INA", "+SOC_INA", "+VDD_1V8_IO", "+SRAM_INA"]
            }
