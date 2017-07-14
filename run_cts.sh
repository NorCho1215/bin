#!/bin/bash

#export PATH=/usr/lib/jvm/java-7-openjdk-amd64/bin:$PATH 
/home/ncho/bin/adb root
sleep 3
/home/ncho/bin/adb remount 
cd ~/Projects/upload/Nvbug/CTS/Android_L/android-cts-media-1.1/
adb shell mkdir /sdcard/test/
adb push android-cts-media-1.1 /sdcard/test/
cd ~/Projects/upload/Nvbug/CTS/Android_L/android-cts-5.1_r1-linux_x86-arm/android-cts/tools
#sudo su
#echo "export PATH=/usr/lib/jvm/java-7-openjdk-amd64/bin:$PATH"
#echo "./cts-tradefed"
