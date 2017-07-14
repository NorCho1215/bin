#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "command: test_mic.sh <MVC/None> <volume>"
else

adb shell rm /sdcard/record*
if [ "$1" == "None" ]; then
  adb reboot
  adb wait-for-device
  sleep 20
  echo "Don't used the MVC"
  adb shell saf775x_util cset adc1-conf 4
  adb shell saf775x_util cset adcen-conf 0
  if [ "$2" != "origial" ]; then
      echo "vol=$2"
      adb shell saf775x_util vset sec2-vol1 $2
      adb shell saf775x_util vset sec2-vol2 $2
  else
      echo "Used origial volume"
  fi
elif [ "$1" == "MVC" ]; then
  adb reboot
  adb wait-for-device
  sleep 20
  "Used MVC vol=$2"
  adb shell saf775x_util cset adc1-conf 4
  adb shell saf775x_util cset adcen-conf 0
  adb shell tinymix -D 1 "ADX1 Mux" I2S3
  adb shell tinymix -D 1 "MVC1 Mux" "ADX1-1"
  adb shell tinymix -D 1 "ADMAIF1 Mux" "MVC1"
  adb shell tinymix -D 1 "MVC1 Mute" "0"
  adb shell tinymix -D 1 "MVC1 Vol" $2
fi
adb shell ls /sdcard/record*
fi
