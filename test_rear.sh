#!/bin/bash
FILE_NAME=$1
i=0
times_i=$RANDOM
RANGE=120
adb shell cat proc/kmsg >> test_early_app_$FILE_NAME.log &
adb logcat -v time >> test_early_app_$FILE_NAME.log &
echo "test start >>>>" >> test_early_app_$FILE_NAME.log 2>&1
echo `date` >> test_early_app_$FILE_NAME.log 2>&1
while [ "$i" != "2000" ]
do
    i=$(($i+1))
    times_i=$RANDOM
    times_i=$((($times_i)%($RANGE)))
    echo `date` >> test_early_app_$FILE_NAME.log 2>&1
    echo "~~~>>> ==test $i times delay=$times_i==" >> test_early_app_$FILE_NAME.log 2>&1
    adb shell 'echo early=cam > /dev/block/mtdblock6' >> test_early_app_$FILE_NAME.log 2>&1
    j=`adb shell getprop media.rear.camera` >> test_early_app_$FILE_NAME.log 2>&1
    echo "$i ~~~>>> rear mode ~~ media.rear.camera=$j" >> test_early_app_$FILE_NAME.log 2>&1
    echo "$i=$times_i  ~~~>>> rear mode ~~ media.rear.camera=$j"
    if [ "$j" == "0" ]; then
         adb shell 'cat /dev/mtd/mtd0' >> test_early_app_$FILE_NAME.log 2>&1
         echo "Get problem with rear mode please check with $i times!!!"
    fi
    sleep $times_i
    adb shell 'echo early=vid > /dev/block/mtdblock6' >> test_early_app_$FILE_NAME.log 2>&1
    j=`adb shell getprop media.rear.camera` >> test_early_app_$FILE_NAME.log 2>&1
    echo "$i~~~>>> normal mode ~~ media.rear.camera=$j" >> test_early_app_$FILE_NAME.log 2>&1
    echo "$i=$times_i~~~>>> normal mode ~~ media.rear.camera=$j"
    if [ "$j" == "1" ]; then
         adb shell 'cat /dev/mtd/mtd0' >> test_early_app_$FILE_NAME.log 2>&1
         echo "Get problem with normal mode please check with $i times!!!"
    fi
    sleep $times_i
done

echo "test finish >>>>" >> test_early_app_$FILE_NAME.log 2>&1
echo `date` >> test_early_app_$FILE_NAME.log 2>&1

