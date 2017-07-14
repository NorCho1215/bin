#!/bin/bash
FILE_NAME=$1
i=0
count=$2

if [ "$#" -lt 2 ]; then
    echo "command: test_audio_module_reboot.sh <FILE_NAME> <count>"
    exit 0
fi
/home/ncho/bin/phidget-ctrl.sh reset
sleep 30
while [ "$i" != "$count" ]
do
 i=$(($i+1))
  echo "test count =$i"
  /home/ncho/bin/adb shell echo "=================Test count=$i ========================" |tee -a test_memory_leak_log_$FILE_NAME.log
  adb shell /system/xbin/su root procrank |grep tuner |tee -a test_memory_leak_log_$FILE_NAME.log
  sleep 1
done
