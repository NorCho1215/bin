#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

project=$2
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/build_android.sh <folder> <project> <clean>"
else
    cd $code_path/$1 #for code folder
    test -d $code_path/$1/.repo && rm out -rf
    echo "Daily build linux process start" > build_android_$2.log 2>&1
    echo `date` >> build_android_$2.log 2>&1
    echo "build_p.sh ---> folder=$1 project=$2" >> debug_script.log
    if [ "$2" == "p1859ref" ]; then
         echo "build_p.sh special for p1859ref project ---> folder=$1 project=$2" >> debug_script.log
         prebuilts/misc/linux-x86/ccache/ccache -M 50G
         #export TOP=$(pwd) && . build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_$1.log 2>&1
         export TOP=$(pwd) &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_android_$2.log 2>&1
    else
         echo "build_p.sh special for common project ---> folder=$1 project=$2" >> debug_script.log
         prebuilts/misc/linux-x86/ccache/ccache -M 50G
         export TOP=$(pwd) &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_android_$2.log 2>&1
    fi
    echo "Daily build linux process end" >> build_android_$2.log 2>&1
    echo `date` >> build_android_$2.log 2>&1
fi
