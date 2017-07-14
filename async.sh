#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/async.sh <reset device Y/N>"
else
 if [ "$1" == "Y" ]; then 
     /home/ncho/bin/adb wait-for-device
     /home/ncho/bin/adb remount && /home/ncho/bin/adb sync && /home/ncho/bin/adb shell sync && /home/ncho/bin/phidget-ctrl.sh reset
 else
     /home/ncho/bin/adb wait-for-device
     /home/ncho/bin/adb remount && /home/ncho/bin/adb sync && /home/ncho/bin/adb shell sync
 fi
fi
