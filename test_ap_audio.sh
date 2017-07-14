#!/bin/bash
FILE_NAME=$2
i=0
j=0
count=$3
image_path=$1
MM_path="/home/ncho/Projects/upload/MM_file/audio/Audio/Dec/AAC"
if [ "$#" -lt 3 ]; then
    echo "command: test_ap_audio.sh <image_path> <FILE_NAME> <count>"
    exit 0
fi
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 result=0
 /home/ncho/bin/flash_V4A_SS.sh $image_path
 echo "test count =$i"
 echo "=================Test count=$i ========================" |tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb wait-for-device
 sleep 20
 /home/ncho/bin/adb shell tegrastats &
 j=0
 while [ "${result:0:1}" != "1" ]
 do
        j=$(($j+1))
	sleep 1
	result=`adb shell getprop sys.boot_completed`
        if [ "$j" == "2000" ]; then
            echo "device cannot boot up"
            exit -1
        fi
 done
 echo "sys.boot_completed=${result:0:1}"
 echo "~~~ sleep time=$j"

 adb remount
 adb push /home/ncho/1T/V4A_rel-25/android/out/target/product/vcm31t186/system/vendor/lib/nvmmlite_audiodec_test.so system/vendor/lib/nvmmlite_audiodec_test.so
 adb push /home/ncho/Projects/upload/MM_file/audio/Audio/Dec/AAC /sdcard/
 adb shell sync 
 echo "start ===== `date`" |tee -a test_audio_module_log_$FILE_NAME.log
 time adb shell "nvtest nvmmlite_audiodec_test.so /sdcard/al00_08.mp4 /data/aac_output.pcm -eaacplus -conf -c 1" | tee -a test_audio_module_log_$FILE_NAME.log
 echo "END ===== `date`" |tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb logcat -v time >> test_audio_module_log_$FILE_NAME.log &
 /home/ncho/bin/phidget-ctrl.sh reset
 echo "=================Test count=$i-2 ========================" |tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb wait-for-device
 sleep 20
 /home/ncho/bin/adb shell tegrastats &
 j=0
 while [ "${result:0:1}" != "1" ]
 do
        j=$(($j+1))
        sleep 1
        result=`adb shell getprop sys.boot_completed`
        if [ "$j" == "2000" ]; then
            echo "device cannot boot up"
            exit -1
        fi
 done
 echo "sys.boot_completed=${result:0:1}"
 echo "~~~ sleep time=$j"
 adb remount
 adb push /home/ncho/1T/V4A_rel-25/android/out/target/product/vcm31t186/system/vendor/lib/nvmmlite_audiodec_test.so system/vendor/lib/nvmmlite_audiodec_test.so
 adb push /home/ncho/Projects/upload/MM_file/audio/Audio/Dec/AAC /sdcard/
 adb shell sync
 time adb shell "nvtest nvmmlite_audiodec_test.so /sdcard/al00_08.mp4 /data/aac_output.pcm -eaacplus -conf -c 1" | tee -a test_audio_module_log_$FILE_NAME.log
 /home/ncho/bin/adb logcat -v time >> test_audio_module_log_$FILE_NAME.log &
done
