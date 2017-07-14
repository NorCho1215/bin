#!/bin/bash
i=0
count=$1
default_path=/home/ncho/1T
if [ "$#" -lt 3 ]; then
    echo "command: test_Stability.sh <count> <folder> <project>"
    exit 0
fi
rm $default_path/Data_build/*
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 /home/ncho/bin/daily_build_V4A.sh $2 $3 N
 cp $default_path/$2/android/build_$2_$3.log $default_path/Data_build/build_$2_$3_$i.log
done
