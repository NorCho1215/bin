# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina219 import INA219
from power import power

class dalmore_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # Enable PM_BUS_SEL
        i2c.mpsse.writeb(port=0, bit=4, val=0)

        if variant and variant.upper() in ['DAQ']:
            # DAQ reworked Dalmore
            self.pm_devs = {
                "VDD_12V_DCIN_RS" :       INA219(i2c, 0x40, 0.010, "VDD_12V_DCIN_RS", imax=3000), #RS15
                "VDD_AC_BAT_VIN1" :       INA219(i2c, 0x41, 0.100, "VDD_AC_BAT_VIN1", imax=2048), #RS9
                "VDD_5V0_SYS" :           INA219(i2c, 0x42, 0.005, "VDD_5V0_SYS", imax=4096), #RS18
                "VDD_3V3_SYS" :           INA219(i2c, 0x43, 0.050, "VDD_3V3_SYS", imax=4096), #RS568
                "VDD_3V3_SYS_VIN4_5_7" :  INA219(i2c, 0x44, 0.010, "VDD_3V3_SYS_VIN4_5_7", imax=2048), #RS560
                "AVDD_USB_HDMI" :         INA219(i2c, 0x45, 0.010, "AVDD_USB_HDMI", imax=2048), #RS37
                "VDD_AC_BAT_D1" :         INA219(i2c, 0x46, 0.250, "VDD_AC_BAT_D1", imax=4200), #RS31
                "VDD_AO_SMPS12_IN" :      INA219(i2c, 0x47, 0.050, "VDD_AO_SMPS12_IN", imax=3000), #RS552
                "VDD_3V3_SYS_SMPS45_IN" : INA219(i2c, 0x48, 0.100, "VDD_3V3_SYS_SMPS45_IN", imax=2048), #RS556
                "VDD_AO_SMPS2_IN" :       INA219(i2c, 0x49, 0.100, "VDD_AO_SMPS2_IN", imax=2048), #RS559
                #"VDDIO_HV_AP" :           INA219(i2c, 0x4A, 0.250, "VDDIO_HV_AP", imax=1000), #RS520
                "VDD_1V8_LDO3_IN" :       INA219(i2c, 0x4B, 0.010, "VDD_1V8_LDO3_IN", imax=2048), #RS23
                "VDD_3V3_SYS_LDO4_IN" :   INA219(i2c, 0x4C, 0.100, "VDD_3V3_SYS_LDO4_IN", imax=2048) ,#RS555
                "VDD_AO_LDO8_IN" :        INA219(i2c, 0x4D, 0.100, "VDD_AO_LDO8_IN", imax=2048), #RS22
                "VDD_1V8_AP" :            INA219(i2c, 0x4E, 0.250, "VDD_1V8_AP", imax=2048), #RS521
                "VDD_1V8_DSM" :           INA219(i2c, 0x4F, 0.250, "VDD_1V8_DSM", imax=2048) #RS61
                }
        else:
            # "normal" Dalmore
            self.pm_devs = {
                "VDD_12V_DCIN_RS" :       INA219(i2c, 0x40, 0.010, "VDD_12V_DCIN_RS", imax=3000), #RS15
                "VDD_AC_BAT_VIN1" :       INA219(i2c, 0x41, 0.010, "VDD_AC_BAT_VIN1", imax=2048), #RS9
                "VDD_5V0_SYS" :           INA219(i2c, 0x42, 0.005, "VDD_5V0_SYS", imax=4096), #RS18
                "VDD_3V3_SYS" :           INA219(i2c, 0x43, 0.005, "VDD_3V3_SYS", imax=4096), #RS568
                "VDD_3V3_SYS_VIN4_5_7" :  INA219(i2c, 0x44, 0.010, "VDD_3V3_SYS_VIN4_5_7", imax=2048), #RS560
                "AVDD_USB_HDMI" :         INA219(i2c, 0x45, 0.010, "AVDD_USB_HDMI", imax=2048), #RS37
                "VDD_AC_BAT_D1" :         INA219(i2c, 0x46, 0.010, "VDD_AC_BAT_D1", imax=4200), #RS31
                "VDD_AO_SMPS12_IN" :      INA219(i2c, 0x47, 0.010, "VDD_AO_SMPS12_IN", imax=3000), #RS552
                "VDD_3V3_SYS_SMPS45_IN" : INA219(i2c, 0x48, 0.010, "VDD_3V3_SYS_SMPS45_IN", imax=2048), #RS556
                "VDD_AO_SMPS2_IN" :       INA219(i2c, 0x49, 0.010, "VDD_AO_SMPS2_IN", imax=2048), #RS559
                #"VDDIO_HV_AP" :           INA219(i2c, 0x4A, 0.010, "VDDIO_HV_AP", imax=1000), #RS520
                "VDD_1V8_LDO3_IN" :       INA219(i2c, 0x4B, 0.010, "VDD_1V8_LDO3_IN", imax=2048), #RS23
                "VDD_3V3_SYS_LDO4_IN" :   INA219(i2c, 0x4C, 0.010, "VDD_3V3_SYS_LDO4_IN", imax=2048), #RS555
                "VDD_AO_LDO8_IN" :        INA219(i2c, 0x4D, 0.010, "VDD_AO_LDO8_IN", imax=2048), #RS22
                "VDD_1V8_AP" :            INA219(i2c, 0x4E, 0.010, "VDD_1V8_AP", imax=2048), #RS521
                "VDD_1V8_DSM" :           INA219(i2c, 0x4F, 0.010, "VDD_1V8_DSM", imax=2048) #RS61
                }

        self.pm_subsets = {
            "Total_Power" : ["+VDD_12V_DCIN_RS"],
            "Backlight" : ["+VDD_AC_BAT_VIN1"],
            "Display_Subsystem" : ["+VDD_AC_BAT_VIN1", "+VDD_3V3_SYS_VIN4_5_7"],
            "DRAM" : ["+VDD_AO_SMPS12_IN"],
            "CPU" : ["+VDD_AC_BAT_D1"],
            "CORE" : ["+VDD_3V3_SYS_SMPS45_IN"],
            "APRAM" : ["+VDD_AO_SMPS12_IN", "+VDD_AC_BAT_D1", "+VDD_3V3_SYS_SMPS45_IN"]
        }

        return

    def __del__(self):
        # Disable PM_BUS_SEL
        self.i2c.mpsse.writeb(port=0, bit=4, val=1)
