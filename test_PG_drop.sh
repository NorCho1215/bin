#!/bin/bash
adb root
adb shell setenforce permissive
adb remount 
adb shell mkdir -p /etc/tuner/
adb push 3rdparty/pelagicore/tuner/pcoreutils/tunerpref/dirana3tuner_pri.conf /etc/tuner/dirana3tuner.conf
adb push 3rdparty/pelagicore/tuner/pcoreutils/tunerpref/lowleveltuner.conf /etc/tuner/
adb push 3rdparty/pelagicore/tuner/pcoreutils/tunerpref/pcoretuner.conf /etc/tuner/
adb shell sync
sleep 3
adb shell tunerservice /system/lib64/libpcoretuner.so /system/lib64/libdirana3tuner.so
