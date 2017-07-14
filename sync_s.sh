#!/bin/bash
adb remount 
adb sync 
adb shell sync 
adb shell sync 
sleep 1
/home/ncho/bin/phidget-ctrl.sh reset 
