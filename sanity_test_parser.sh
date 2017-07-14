#!/bin/bash
i=0
key_word=$1 
key_word2=$2
if [ "$#" -lt 1 ]; then
    echo "command: sanity_test_paser.sh <key_word> <ker_word2>"
    exit 0
fi
previous_pid="NULL"

if [ "$key_word2" == "" ]; then 
    grep "$key_word" detailedlog_* -rns |awk '{print $1}' > file_name.id
else
    grep "$key_word" detailedlog_* -rns |grep "$key_word2" |awk '{print $1}' > file_name.id
fi
exec < file_name.id
while read line
do
        if [ "${line:12:9}" != "$previous_pid" ]; then
            i=$(($i+1))
	    echo "$i = http://ausvrl/showjob.php?job=${line:12:9}"
            message=`grep "$key_word" detailedlog_${line:12:9}.txt -r3`
            echo "$message"
            previous_pid=${line:12:9}
        fi
done
rm file_name.id
