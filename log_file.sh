#!/bin/bash

phidget-ctrl.sh reset
adb wait-for-device

if [ "$1" != "" ]; then 
  adb shell cat proc/kmsg >> $1 &
  adb shell logcat -v time >> $1 &
else
  rm log_file.log
  adb shell cat proc/kmsg >> log_file.log &
  adb shell logcat -v time >> log_file.log &
fi
