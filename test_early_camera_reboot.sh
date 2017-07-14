#!/bin/bash
FILE_NAME=$1
i=0
count=$2

if [ "$#" -lt 2 ]; then
    echo "command: test_early_camera.sh <FILE_NAME> <count>"
    exit 0
fi
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "test count =$i"
 adb wait-for-device
 echo "video mode"
 adb shell echo "=================Test count=$i ========================">>test_early_camera_log_$FILE_NAME.log 2>&1
 adb shell cat proc/kmsg |grep early >> test_early_camera_log_$FILE_NAME.log &
 sleep 15
 adb shell ps |grep early
 Stream01=`adb shell ps |grep nvmedia_earlyca |awk '{print $8}'` ### |cut -d '/' -f 4`
 echo ${Stream01}
 if [ "${Stream01}" != "R" ];then
   echo "error Get nvmedia_earlycamera problem"
   exit -1;
 fi
 echo "rear camera"
 adb reboot
done
