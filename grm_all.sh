#!/bin/bash
declare -i s
s=0
rm_data=`git status |grep deleted | awk '{print $2}'`
for rm_name in $rm_data
do
        s=s+1
	echo "$s $rm_name"
        git rm $rm_name
        git status
done

