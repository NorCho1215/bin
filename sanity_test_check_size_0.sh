#!/bin/bash
i=0
echo "command: sanity_test_check_size_0.sh"
previous_pid="NULL"
ls -la summary* > file_name.id
exec < file_name.id
while read line
do
    tmp1=`echo $line |awk '{print $5}'`
    ##echo "$tmp1"
    if [ "$tmp1" == "0" ]; then
       tmp2=`echo $line |awk '{print $9}'`
       echo "http://ausvrl/showjob.php?job=${tmp2:8:9}"
    fi
done
rm file_name.id
