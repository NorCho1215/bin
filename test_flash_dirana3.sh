#!/bin/bash
if [ ! -e $BINARY_PATH/Arm_Ffs_nxp_signed.bin ]; then
      `ls $BINARY_PATH/Arm_Ffs_nxp_signed.bin`
      echo "Please export BINARY_PATH for install"
      echo "BINARY_PATH : NXP binary folder"
      echo "example: export BINARY_PATH=/home/ncho/dirana3/R7.0/firmware_engg"
      exit 1
fi
echo "push binary to device"
adb push $BINARY_PATH sdcard

adb shell saf775x_util bootFromRom
echo "saf775x_util erase /sdcard/Arm_Ffs_nxp_signed.bin"
adb shell saf775x_util erase /sdcard/Arm_Ffs_nxp_signed.bin
#sleep 4
#To flash new firmware binaries
echo "saf775x_util flashinit /sdcard/Arm_Ffs_nxp_signed.bin"
adb shell saf775x_util flashinit /sdcard/Arm_Ffs_nxp_signed.bin
#sleep 4
echo "saf775x_util flashinit /sdcard/Arm_Ffs_nxp_signed.bin"
adb shell saf775x_util flashinit /sdcard/Arm_Ffs_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 0 0 /sdcard/Dirana3_BBP_E7A0_nxp_signed.bin"
adb shell saf775x_util flash 0 0 /sdcard/Dirana3_BBP_E7A0_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 1 0 /sdcard/Dirana3_BBP_E7A1_nxp_signed.bin"
adb shell saf775x_util flash 1 0 /sdcard/Dirana3_BBP_E7A1_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 2 0 /sdcard/Dirana3_BBP_E7A2_nxp_signed.bin"
adb shell saf775x_util flash 2 0 /sdcard/Dirana3_BBP_E7A2_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 3 0 /sdcard/Dirana3_ABB_E7A0_nxp_signed.bin"
adb shell saf775x_util flash 3 0 /sdcard/Dirana3_ABB_E7A0_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 4 0 /sdcard/Dirana3_ABB_E7A1_nxp_signed.bin"
adb shell saf775x_util flash 4 0 /sdcard/Dirana3_ABB_E7A1_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 6 0 /sdcard/Dirana3_ICC_ARM0_upper_nxp_signed.bin"
adb shell saf775x_util flash 6 0 /sdcard/Dirana3_ICC_ARM0_upper_nxp_signed.bin
#sleep 4
echo "saf775x_util flash 6 1 /sdcard/Dirana3_ICC_ARM0_lower_nxp_signed.bin"
adb shell saf775x_util flash 6 1 /sdcard/Dirana3_ICC_ARM0_lower_nxp_signed.bin
#sleep 4

# initialize dirana3
adb shell saf775x_util bootFromFlash

#enable SRC
adb shell saf775x_util vset src0-set 0x800000
adb shell saf775x_util vset src1-set 0x800000
adb shell saf775x_util vset src4-set 0x800000

#enable tdm1 as primary input
adb shell saf775x_util pset tdm1-out pri-input

#enable swdac output
adb shell saf775x_util pset front-out-l swdac-in

#enable adc01 as secondary2 input
adb shell saf775x_util pset an01-out sec2-input
adb shell saf775x_util pset sec2-out-r tdm0-in1

#enable src0outpntr as bt uplink
adb shell saf775x_util pset sec2-out  bt-input

#enable i2s2 as secondary input
adb shell saf775x_util pset i2s2-out sec-input
adb shell saf775x_util pset sec-out tdm0-in2

#volume and mute setting
adb shell saf775x_util vset pri-mute 0x07ff
adb shell saf775x_util vset pri-vol1 0x00ff
adb shell saf775x_util vset pri-vol2 0x0080

adb shell saf775x_util vset sec-mute 0x07ff
adb shell saf775x_util vset sec-vol1 0x00ff
adb shell saf775x_util vset sec-vol2 0x0653

adb shell saf775x_util vset sec2-mute 0x07ff
adb shell saf775x_util vset sec2-vol1 0x03ff
adb shell saf775x_util vset sec2-vol2 0x0653
