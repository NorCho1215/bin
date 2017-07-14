#!/bin/bash
filename='/home/ncho/bin/ap_audio.list'
exec < $filename
while read line
do
	echo $line
	a_file=`find /home/ncho/Projects/upload/MM_file -name $line`
        echo "$a_file"
        /home/ncho/bin/adb remount 
        #/home/ncho/bin/adb push /home/ncho/Projects/upload/MM_file/$a_file /data/audio/sanity/
        
done 
