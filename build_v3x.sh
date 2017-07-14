#!/bin/bash

code_path="/home/ncho/1T"

export P4ROOT="/home/ncho/Projects/upload/p4"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
code_folder=$code_path/$1
if [ "$#" -lt 3 ]; then
    	echo "command: /home/ncho/bin/build_v3x.sh <folder> <android-project> <re-sync>"
        echo "example: /home/ncho/bin/build_v3x.sh v3x-beta3 p1859ref N"
        echo "example: /home/ncho/bin/build_v3x.sh v3x-main p1859ref R"
 # check the folder
else
    cd $code_folder
    test ! -d $code_folder && echo "Don't have code folder" > build_$1_$2.log && exit 1
    if [ "$2" == "Init" ]; then
       echo "Not ready!!!"
    else
        test ! -d $code_folder/linux/.repo && echo "Don't have linux code" >> build_$1_$2.log && exit 1
        test ! -d $code_folder/android/.repo && echo "Don't have android code" >> build_$1_$2.log && exit 1
        test ! -d $code_folder/foundation/.repo && echo "Don't have foundation code" >> build_$1_$2.log && exit 1
        if [ "$3" == "R" ]; then
             cd $code_folder/linux/
             echo "sync linux"
             test -d .repo && rm * -rf
             test -d .repo && /usr/local/bin/repo sync -j4 >> sync_$1_$2.log 2>&1
             cd $code_folder/android/
             echo "sync android"
             test -d .repo && rm * -rf
             test -d .repo && /usr/local/bin/repo sync -j4 >> sync_$1_$2.log 2>&1
             cd $code_folder/foundation/
             echo "sync foundation"
             test -d .repo && rm * -rf
             test -d .repo && /usr/local/bin/repo sync -j4 >> sync_$1_$2.log 2>&1
        fi
        /home/ncho/bin/build_android.sh $1/android $2 $3
        echo $passww|sudo -S -s /home/ncho/bin/build_linux.sh $1/linux
        /home/ncho/bin/build_foundation.sh $1/foundation
    fi
fi
