#!/bin/bash
echo "Build F = $PWD"
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
folder=$1
project=$2
bacup_name=`date |awk '{print $6_$2_$3}'`
log_path=$code_path/$1/foundation/build_$1_$2_$bacup_name.log
build_folder=$code_path/$folder/foundation
if [ "$#" -lt 2 ]; then
    echo "command: /home/autotw/bin/build_V4A_f.sh <folder> <project>"
else
    echo "start build with foundation" > $log_path 2>&1
    echo "start build with foundation"
    export TOP_V4F=$build_folder
    cd $TOP_V4F
    echo $TOP_V4F
    echo "build_V4A_f.sh ---> folder=$1 project=$2" >> $log_path 2>&1
    echo "Daily build start build 333" >> $log_path 2>&1
    echo `date` >> $log_path 2>&1
    if [ "$2" == "vcm31t210ref" ]; then
         echo "build_V4A_f.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf 
         source tmake/scripts/envsetup.sh && choose embedded-foundation t210ref none release && tmp >> $log_path 2>&1
    elif [ "$2" == "vcm31t186ref" ]; then
         echo "build_V4A_f.sh special for vcm31t186ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf
         export TOP=$(pwd)
         export TEGRA_TOP=$(pwd)
         export TOOLCHAIN_PREFIX=arm-none-eabi-
         export TARGET_PRODUCT=t186ref_int
         source tmake/scripts/envsetup.sh && choose embedded-foundation t186ref none release && tmp >> $log_path 2>&1
    fi
fi
