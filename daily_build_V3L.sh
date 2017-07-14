#!/bin/bash

code_path="/home/ncho/1T"

export P4ROOT="/home/ncho/Projects/upload/p4"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
code_folder=$code_path/$1
if [ "$#" -lt 3 ]; then
    	echo "command: /home/ncho/bin/daily_build_V3L.sh <folder> <android-project> <re-sync>"
        echo "example: /home/ncho/bin/daily_build_V3L.sh linux p1859ref N"
        echo "example: /home/ncho/bin/daily_build_V3L.sh linux p1859ref Y"
 # check the folder
else
    cd $code_folder
    test ! -d $code_folder && echo "Don't have code folder" > build_$1_$2.log && exit 1
    if [ "$2" == "Init" ]; then
       echo "Not ready!!!"
    else
        test ! -d $code_folder/.repo && echo "Don't have linux code" >> build_$1_$2.log && exit 1
        if [ "$3" == "Y" ]; then
             cd $code_folder/
             echo "sync linux"
             test -d .repo && rm * -rf
             test -d .repo && /usr/local/bin/repo sync -cj4 >> sync_$1_$2.log 2>&1
        fi
        echo $passww|sudo -S /home/ncho/bin/build_linux.sh $1
    fi
fi
