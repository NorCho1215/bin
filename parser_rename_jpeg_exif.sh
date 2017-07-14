#!/bin/bash
folder=$1
i=1
if [ "$#" -lt 1 ]; then
    echo "command: parser_rename_jpeg_exif.sh <target folder>"
else

test ! -d result && mkdir result
cd $folder
file_list=`find . |grep -i "JPG\|JPEG\|jpg\|jpeg"`
file_name=`echo $file_list|awk -v j=$i '{print $j}'`
while [ -n "${file_name}" ]
do
    i=$(($i+1))
    file_name_p=`echo ${file_name:2}`
    echo file_name=$file_name_p
    date_tmp=`exif $file_name_p | grep "Date and Time" |grep Digit |awk '{print $4}'`
    echo date_tmp=$date_tmp
    date=`echo ${date_tmp:7}`
    echo date=$date
    time=`exif $file_name_p | grep "Date and Time" |grep Digit |awk '{print $5}'`
    echo time=$time
    modify_name=${date}_${time}_${folder}
    modify_name=`echo $modify_name |sed 's/://g'`
    echo $modify_name
    cp $file_name_p ../result/$modify_name.JPG
    file_name=`echo $file_list|awk -v j=$i '{print $j}'`
done 

fi

exit
