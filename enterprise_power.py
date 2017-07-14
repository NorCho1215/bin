# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina219 import INA219
from power import power

class enterprise_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        self.pm_devs = {
            ## Note: this calibration constant is tuned for SQA's autopower setup.  By default, it should be 0xfa00
            "VDD_BAT_Power" : INA219(self.i2c, 0x40, 2, "VDD_AC_BAT_Power", cal=0xf780, power_lsb=6.4), #PM1, 3.7V #enabled via rework
            "VDD_CORE_track_Power" : INA219(self.i2c, 0x41, 20, "VDD_CORE_track_Power", cal=0xa000, power_lsb=1), #PM2, ~4V

            "VDD_DRAM_1V2_Power" : INA219(self.i2c, 0x42, 10, "VDD_DRAM_1V2_Power", cal=0xa000, power_lsb=2), #PM3, 1.2V
            "VBAT_MODEM_Power" : INA219(self.i2c, 0x43, 10, "VBAT_MODEM_Power", cal=0xa000, power_lsb=2), #PM4, ~4V
            # PM5 omitted from board due to SELF.I2C address conflict
            "VDDIO_NAND_1V8_Power" : INA219(self.i2c, 0x45, 200, "VDDIO_NAND_1V8_Power", cal=0xa000, power_lsb=.1), #PM6, 1.8V
            "VDD_EMMC_2V85_Power" : INA219(self.i2c, 0x46, 30, "VDD_EMMC_2V85_Power", cal=0xd555, power_lsb=.5), #PM7, 2.85V
            "VDD_MODEM_1V8_Power" : INA219(self.i2c, 0x47, 200, "VDD_MODEM_1V8_Power", cal=0x5000, power_lsb=.2), #PM8, 1.8V
            "VBAT_WFBT_Power" : INA219(self.i2c, 0x48, 200 , "VBAT_WFBT_Power", cal=0x5000, power_lsb=.2), #PM9, ~4V
            "VDDIO_WFBT_1V8_Power" : INA219(self.i2c, 0x49, 1000, "VDDIO_WFBT_1V8_Power", cal=0x4000, power_lsb=.05), #PM10, 1.8V
            "VDDIO_AUDIO_1V8_Power" : INA219(self.i2c, 0x4a, 1000, "VDDIO_AUDIO_1V8_Power", cal=0x4000, power_lsb=.05), #PM11, 1.8V
            "VDD_SPKR_Power" : INA219(self.i2c, 0x4b, 30, "VDD_SPKR_Power", cal=0x6aaa, power_lsb=1), #PM12, ~4V
            "VBAT_BACKLIGHT_Power" : INA219(self.i2c, 0x4c, 30, "VBAT_BACKLIGHT_Power", cal=0xd555, power_lsb=.5), #PM13, ~4V
            "PMU_USB_VBUS_Power" : INA219(self.i2c, 0x4d, 10, "PMU_USB_VBUS_Power", cal=0xa000, power_lsb=2), #PM14, 5V
            "VDD_LPDDR2_1V8_Power" : INA219(self.i2c, 0x4e, 510, "VDD_LPDDR2_1V8_Power", cal=0x7d7d, power_lsb=.05), #PM15, 1.8V
            "VDD_CPU_Power" : INA219(self.i2c, 0x4f, 30, "VDD_CPU_Power", cal=0x6aaa, power_lsb=1), #PM16, ~4V
            }

        self.pm_subsets = {
            "All_Rails" : ['+'+x for x in self.pm_devs.keys()]
            }
        return

