#!/bin/bash
file_name=$1
if [ "$#" -lt 1 ]; then
    echo "command: sanity_test_check.sh <FILE_NAME>"
    exit 0
fi
cat $file_name |grep job |awk '{print $5}' > ${file_name}.id
mkdir ${file_name}_check
mv ${file_name}.id ${file_name}_check
cd ${file_name}_check
exec < ${file_name}.id
while read line
do
	echo id=$line
	echo " Get this http://ausvrldsk.nvidia.com/jobs/${line:0:6}/$line/summary.txt"
        wget http://ausvrldsk.nvidia.com/jobs/${line:0:6}/$line/summary.txt -O summary_${line}.txt
        axel -n 5 http://ausvrldsk.nvidia.com/jobs/${line:0:6}/$line/detailedlog.txt -o detailedlog_${line}.txt
done

