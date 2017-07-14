
adb wait-for-device
adb remount
FW_path=/home/ncho/Projects/upload/Nvbug/Radio/saturn_sabre/SAF36xx_REL_DAB_CR7.3.12/SAF36xx_REL_DAB_CR7.3.12/DAB_sw
adb push $FW_path/SAF36xx_DAB_CR7.3.12_20150423_1515_retail_sf3_RefSetup_RFE_RI_VS_vg_cs10-13_encNXD.bin /system/vendor/firmware/SAF36xx_DAB.bin
adb shell sync
adb shell sync
adb shell /system/vendor/bin/saf36xx_util load /system/vendor/firmware/SAF36xx_DAB.bin
