#!/bin/bash
#data='date +%x'
/home/ncho/bin/adb wait-for-device
/home/ncho/bin/adb root
sleep 3
/home/ncho/bin/adb shell cat proc/kmsg >>  message_$1.log &
/home/ncho/bin/adb logcat -v time  >>  message_$1.log &
