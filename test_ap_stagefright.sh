#!/bin/bash
FILE_NAME=$1
i=0
count=$2

if [ "$#" -lt 2 ]; then
    echo "command: test_ap_stagefright.sh <FILE_NAME> <count>"
    exit 0
fi
/home/ncho/bin/adb wait-for-device
/home/ncho/bin/adb push /home/ncho/Projects/upload/MM_file/MM-stress/video/T30-AP30/h265_bunny1_fr81-801_881-2000_1080p_30fps_10Mbps_noBFr_aac.mp4 /sdcard/
/home/ncho/bin/adb shell sync
/home/ncho/bin/adb install -r AMAFUI.apk
/home/ncho/bin/adb shell sync
#/home/ncho/bin/phidget-ctrl.sh reset
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "test count =$i"
 /home/ncho/bin/adb wait-for-device
 sleep 20
 /home/ncho/bin/adb logcat -c
 echo "=================Test count=$i ========================" |tee -a test_audio_module_log_$FILE_NAME.log
 perl decode_fps_script.pl -f /sdcard/h265_bunny1_fr81-801_881-2000_1080p_30fps_10Mbps_noBFr_aac.mp4 -t 285 -d 150 |tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb logcat -v time >> test_audio_module_log_$FILE_NAME.log &
 #/home/ncho/bin/phidget-ctrl.sh reset
done
