#!/bin/bash
echo "Build Android!!!!!!"
code_path="/home/autotw/work/source"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export P4ROOT="/home/autotw/p4"
PATH=$PATH:/sbin
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache
folder=$1
project=$2
build_path=$code_path/$1/android
bacup_name=`date |awk '{print $6_$2_$3}'`
android_build_log=$build_path/build_$1_$2_$bacup_name.log
if [ "$#" -lt 2 ]; then
    echo "command: /home/autotw/bin/build_V4A_a.sh <folder> <project>"
else
    echo " === START build with android === " > $android_build_log 2>&1
    echo " === START build with android === "
    cd $build_path #for code folder
    echo "$PATH ===>>>>>>> " >> $android_build_log 2>&1
    echo "build_p.sh ---> folder=$1 project=$2" >> $android_build_log 2>&1
    echo "Daily build start build 333" >> $android_build_log 2>&1
    echo `date` >> $android_build_log 2>&1
    if [ "$project" == "vcm31t210ref" ]; then
         echo "build_p.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> $android_build_log 2>&1
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         export TOP=$(pwd) && export SECURE_OS_BUILD=n &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> $android_build_log 2>&1
    else
         echo "build_p.sh special for other project ---> folder=$1 project=$2" >> $android_build_log 2>&1
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         export TOP=$(pwd) && export SECURE_OS_BUILD=n &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev  2>&1 |tee $android_build_log 2>&1
    fi
fi
