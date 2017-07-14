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
 adb root
 sleep 4
 echo "video mode"
 adb shell echo "=================Test count=$i ========================">>test_early_camera_$FILE_NAME.log 2>&1
 adb shell echo "=================Test count=$i ========================">>test_early_camera_log_$FILE_NAME.log 2>&1
 adb shell echo "=================Test count=$i ========================">>test_early_camera_cam_$FILE_NAME.log 2>&1
 adb shell cat proc/kmsg >> test_early_camera_log_$FILE_NAME.log &
 adb logcat -v time >> test_early_camera_log_$FILE_NAME.log &
 adb shell ps |grep early >> test_early_camera_$FILE_NAME.log 2>&1
 adb shell dumpsys SurfaceFlinger |grep "Display 0" -A 24 >> test_early_camera_$FILE_NAME.log 2>&1
 adb shell ps |grep early
 adb shell stop
 sleep 1
 adb shell /early/bin/nvmedia_earlycamera -cf /early/early_camera_OV10635.conf -c dvp-ov10635-yuv422-1280x800-cd -d 0 -w 1 -z 1 >>test_early_camera_cam_$FILE_NAME.log 2>&1 &
 echo "!!!!!!!!!!!!!"
 Stream01=`adb shell ps |grep nvmedia_earlyca |awk '{print $8}'` ### |cut -d '/' -f 4`
 echo ${Stream01}
 if [ "${Stream01}" != "R" ];then
   echo "error Get nvmedia_earlycamera problem"
   exit -1;
 fi
 sleep 2
 echo "rear camera"
 adb reboot
 sleep 20
done
