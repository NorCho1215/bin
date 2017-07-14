# Copyright (c) 2013, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

from ina219 import INA219
from power import power

class norrin_power(power):
    def __init__(self, i2c, variant=None, calibration=None):
        power.__init__(self, i2c, variant, calibration)

        # Enable PM_BUS_SEL
        i2c.mpsse.writeb(port=0, bit=4, val=0)

        if variant and variant.upper() in ['DAQ']:
            daq = True
        else:
            daq = False

        if variant and variant.upper() in ['EARLY']:
            self.pm_devs = {
                "PMU_MUX" :             INA219(i2c, 0x40, 0.001, "PMU_MUX", imax=6000),
                "3.3V_PEX_PLL_AP" :     INA219(i2c, 0x41, 0.5, "3.3V_PEX_PLL_AP", imax=1000),
                "3.3V_VDD_USB_AP" :     INA219(i2c, 0x42, 0.5, "3.3V_VDD_USB_AP", imax=1000),
                "1.05V_AVDD_LVDS_AP" :  INA219(i2c, 0x43, 0.5, "1.05V_AVDD_LVDS_AP", imax=1000),
                "1.8V_VDDIO_SYS_AP" :   INA219(i2c, 0x44, 0.5, "1.8V_VDDIO_SYS_AP", imax=1000),
                "VDD_CORE" :            INA219(i2c, 0x45, 0.003, "VDD_CORE", imax=6000),
                "VDD_CPU" :             INA219(i2c, 0x46, 0.0005, "VDD_CPU", imax=10000),
                "3.3V_AVDD_HDMI_AP" :   INA219(i2c, 0x47, 0.1, "3.3V_AVDD_HDMI_AP", imax=2000),
                "1.35_VDDIO_DDR_AP" :   INA219(i2c, 0x48, 0.001, "1.35_VDDIO_DDR_AP", imax=4000),
                "1.35_VDDIO_DDR" :      INA219(i2c, 0x49, 0.001, "1.35_VDDIO_DDR", imax=4000),
                "VDDIO_BB_AP" :         INA219(i2c, 0x4A, 1.0, "VDDIO_BB_AP", imax=1000),
                "3.3V_HVDD_SATA_AP" :   INA219(i2c, 0x4B, 1.0, "3.3V_HVDD_SATA_AP", imax=1000),
                "VDD_GPU" :             INA219(i2c, 0x4C, 0.001, "VDD_GPU", imax=10000),
                "1.8V_COM" :            INA219(i2c, 0x4D, 0.1, "1.8V_COM", imax=4000),
                "1.05V_AVDDIO_PEX_AP" : INA219(i2c, 0x4E, 0.1, "1.05V_AVDDIO_PEX_AP", imax=4000),
                "3.3V_GPS" :            INA219(i2c, 0x4F, 0.5, "3.3V_GPS", imax=1000)
                }
        elif variant and variant.upper() in ['REVC']:
            # Most T132-A02 boards are rev.C, see below link for details:
            # https://p4viewer.nvidia.com/get///syseng/WMP/Projects/T132/Norrin/Designs/PM374--ERS_Main_Board/B00/Power_sense_res_rework_rev_C.xls
            self.pm_devs = {
                "PMU_MUX" :             INA219(i2c, 0x40, 0.001, "PMU_MUX", imax=6000),
                "3.3V_PEX_PLL_AP" :     INA219(i2c, 0x41,   0.5, "3.3V_PEX_PLL_AP", imax=1000),
                "3.3V_VDD_USB_AP" :     INA219(i2c, 0x42,   0.5, "3.3V_VDD_USB_AP", imax=1000),
                "1.05V_AVDD_LVDS_AP" :  INA219(i2c, 0x43,   0.2, "1.05V_AVDD_LVDS_AP", imax=1000),
                "1.8V_VDDIO_SYS_AP" :   INA219(i2c, 0x44,   0.5, "1.8V_VDDIO_SYS_AP",  imax=1000),
                "VDD_CORE" :            INA219(i2c, 0x45, 0.001, "VDD_CORE", imax=6000),
                "VDD_CPU" :             INA219(i2c, 0x46, 0.001, "VDD_CPU", imax=10000),
                "3.3V_AVDD_HDMI_AP" :   INA219(i2c, 0x47,   0.1, "3.3V_AVDD_HDMI_AP", imax=2000),
                "1.35_VDDIO_DDR_AP" :   INA219(i2c, 0x48, 0.001, "1.35_VDDIO_DDR_AP", imax=4000),
                "1.35_VDDIO_DDR" :      INA219(i2c, 0x49, 0.001, "1.35_VDDIO_DDR", imax=4000),
                "VDDIO_BB_AP" :         INA219(i2c, 0x4A,   1.0, "VDDIO_BB_AP", imax=1000),
                "3.3V_HVDD_SATA_AP" :   INA219(i2c, 0x4B,   1.0, "3.3V_HVDD_SATA_AP", imax=1000),
                "VDD_GPU" :             INA219(i2c, 0x4C, 0.001, "VDD_GPU", imax=10000),
                "1.8V_COM" :            INA219(i2c, 0x4D,   0.1, "1.8V_COM", imax=4000),
                "1.05V_AVDDIO_PEX_AP" : INA219(i2c, 0x4E,  0.02, "1.05V_AVDDIO_PEX_AP", imax=4000),
                "3.3V_GPS" :            INA219(i2c, 0x4F,   0.5, "3.3V_GPS", imax=1000)
            }
        else:
            self.pm_devs = {
                "PMU_MUX" :             INA219(i2c, 0x40, 0.02, "PMU_MUX", imax=6000),
                "3.3V_PEX_PLL_AP" :     INA219(i2c, 0x41, 0.5, "3.3V_PEX_PLL_AP", imax=1000),
                "3.3V_VDD_USB_AP" :     INA219(i2c, 0x42, 0.5, "3.3V_VDD_USB_AP", imax=1000),
                "1.05V_AVDD_LVDS_AP" :  INA219(i2c, 0x43, 0.5, "1.05V_AVDD_LVDS_AP", imax=1000),
                "1.8V_VDDIO_SYS_AP" :   INA219(i2c, 0x44, 0.5, "1.8V_VDDIO_SYS_AP", imax=1000),
                "VDD_CORE" :            INA219(i2c, 0x45, 0.02, "VDD_CORE", imax=6000),
                "VDD_CPU" :             INA219(i2c, 0x46, 0.01 if daq else 0.001, "VDD_CPU", imax=10000),
                "3.3V_AVDD_HDMI_AP" :   INA219(i2c, 0x47, 0.1, "3.3V_AVDD_HDMI_AP", imax=2000),
                "1.35_VDDIO_DDR_AP" :   INA219(i2c, 0x48, 0.01, "1.35_VDDIO_DDR_AP", imax=4000),
                "1.35_VDDIO_DDR" :      INA219(i2c, 0x49, 0.01, "1.35_VDDIO_DDR", imax=4000),
                "VDDIO_BB_AP" :         INA219(i2c, 0x4A, 1.0, "VDDIO_BB_AP", imax=1000),
                "3.3V_HVDD_SATA_AP" :   INA219(i2c, 0x4B, 1.0, "3.3V_HVDD_SATA_AP", imax=1000),
                "VDD_GPU" :             INA219(i2c, 0x4C, 0.02, "VDD_GPU", imax=10000),
                "1.8V_COM" :            INA219(i2c, 0x4D, 0.05, "1.8V_COM", imax=4000),
                "1.05V_AVDDIO_PEX_AP" : INA219(i2c, 0x4E, 0.1, "1.05V_AVDDIO_PEX_AP", imax=4000),
                "3.3V_GPS" :            INA219(i2c, 0x4F, 0.5, "3.3V_GPS", imax=1000)
                }

        self.pm_subsets = {
            "CPU" : ["+VDD_CPU"],
            "GPU" : ["+VDD_GPU"],
            "CORE" : ["+VDD_CORE"],
            "DRAM" : ["+1.35_VDDIO_DDR_AP", "+1.35_VDDIO_DDR"],
            "APRAM" : ["+VDD_CPU", "+VDD_GPU", "+VDD_CORE", "+1.35_VDDIO_DDR_AP", "+1.35_VDDIO_DDR" ],
        }

        return

    def __del__(self):
        # Disable PM_BUS_SEL
        self.i2c.mpsse.writeb(port=0, bit=4, val=1)
