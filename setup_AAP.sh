#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/setup_aap.sh <version>"
else

cd ~/Projects/upload/Nvbug/AAP/$1
adb install AAPDemo.apk
adb root
sleep 3
adb remount
adb push libautoreceiver_jni.so /system/lib64
adb shell sync 
adb shell sync 
sleep 1
phidget-ctrl.sh reset
fi
