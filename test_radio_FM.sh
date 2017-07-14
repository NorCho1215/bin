#!/system/bin/sh
# Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.
#

#input
Source_Selection=$1
Band_Selection=$2
Frequency_Setting=$3
FM_Click_Noise_suppession=$4
FM_Noise_Blanker=$5
AGC_Value=$6
FM_Antenna_Selection=$7
Volume_Setting=$8
Level_offset=$9
softmute=${10}
#High_Cut=${11}
#Tuner_Selection=$ ## not sure how to do.
#AST_level=$
#frequency_AST=$

#output 
Input_Signal_Detector=0
#AST_output=0 # output

if [ "$#" -lt 12 ]; then
    echo "example: command: test_radio_FM.sh primary FM 9970 enable FM 0 A0 0 0 mute"
    echo "id:                                1       2  3    4      5  6 7  8 9 10"
    echo "1.Source_Selection: primary/second radio"
    echo "2.Band_Selection: FM/MW/LW/SW"
    echo "3.Frequency setting: "
    echo "4.FM_Click_Noise_suppession: enable/disable"
    echo "5.FM_Noise_Blanker: FM/AM_low/AM_default/AM_high"
    echo "6.AGC_Value: "
    echo "7.FM_Antenna_Selection: A0/A1"
    echo "8.volume setting: "
    echo "9.Level offset: "
    echo "10:softmute: mute/unmute"
else
    echo "running"
#ID 1: Source_Selection
    if [ "$Input_Signal_Detector" == "primary" ]; then
        adb shell saf775x_util pset pri-radio-out pri-input
    else if [ "$Input_Signal_Detector" == "primary" ]; then
        adb shell saf775x_util pset sec-radio-out pri-input
    fi
#ID 2: 60h
    if [ "$Band_Selection" == "FM" ]; then
        Band_Selection=2#0000000
    else if [ "$Band_Selection" == "MW" ]; then
        Band_Selection=2#0100000
    else if [ "$Band_Selection" == "LW" ]; then
        Band_Selection=2#0010000
    else if [ "$Band_Selection" == "SW" ]; then
        Band_Selection=2#0110000
    fi
#ID 3: 01,02h 61,62h bit=0:7
    Frequency_Setting=$2
#ID 4: 65h
    if [ "$FM_Click_Noise_suppession" == "enable" ]; then
        FM_Click_Noise_suppession=2#1000000
    else if [ "$FM_Click_Noise_suppession" == "disable" ]; then
        FM_Click_Noise_suppession=2#0000000
    fi
#ID 5: 05h 65h (NBSA) (NBSB)
    if 
    
fi
