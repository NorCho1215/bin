#!/bin/bash
export USER=$(whoami)
code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"
PATH=$PATH:/sbin
export USE_CCACHE=0
export CCACHE_DIR=~/.ccache
folder=$1
project=$2
build_path=$code_path/$1/android
android_build_log=$build_path/build_$1_$2.log
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/build_V4A_a.sh <folder> <project>"
else
    echo " === START build with android =$USER== " > $android_build_log 2>&1
    cd $build_path #for code folder
    echo "$PATH ===>>>>>>> " >> $android_build_log 2>&1
    echo "build_p.sh ---> folder=$1 project=$2" >> $android_build_log 2>&1
    echo "Daily build start build 333" >> $android_build_log 2>&1
    echo `date` >> $android_build_log 2>&1
    if [ "$project" == "vcm31t210ref" ]; then
         echo "build_p.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> $android_build_log 2>&1
         #prebuilts/misc/linux-x86/ccache/ccache -M 150G
         export TOP=$(pwd) &&. build/envsetup.sh && setpaths && choosecombo 2 $project 3 && m dev >> $android_build_log 2>&1
    else
         echo "build_p.sh special for other project ---> folder=$1 project=$2" >> $android_build_log 2>&1
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         export TOP=$(pwd) && export SECURE_OS_BUILD=n &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev  2>&1 | tee -a $android_build_log
    fi
fi
