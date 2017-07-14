#!/bin/bash
FILE_NAME=$1
i=0
count=$2

if [ "$#" -lt 2 ]; then
    echo "command: test_audio_module_reboot.sh <FILE_NAME> <count>"
    exit 0
fi
/home/ncho/bin/adb remount
/home/ncho/bin/adb push init_d3.sh system/bin/
/home/ncho/bin/adb shell chmod +x system/bin/init_d3.sh
/home/ncho/bin/adb shell sync
/home/ncho/bin/adb shell sync
/home/ncho/bin/phidget-ctrl.sh reset
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "test count =$i"
 /home/ncho/bin/adb wait-for-device
 /home/ncho/bin/adb shell echo "=================Test count=$i ========================" |tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb logcat -v time >> test_audio_module_log_$FILE_NAME.log &
 echo "start sleep"
 sleep 80
 echo "Test count=$i"
 /home/ncho/bin/adb shell dmesg >> test_audio_module_log_$FILE_NAME.log 2>&1 
 echo "check 1"
 /home/ncho/bin/adb shell dmesg |grep "Failed at I2S2_TX sw reset" && exit -1
 echo "check 2"
 cat test_audio_module_log_$FILE_NAME.log |grep UNDERRUN 
 echo "check 3"
 /home/ncho/bin/phidget-ctrl.sh reset
done
