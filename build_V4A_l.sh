#!/bin/bash
code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"
folder=$1
project=$2
log_path=$code_path/$1/linux/build_$1_$2.log
build_folder=$code_path/$folder/linux
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/build_V4A_l.sh <folder> <project>"
    echo "e.g. /home/ncho/bin/build_V4A_l.sh V4A_Alpha2 vcm31t186ref"
else
    echo "start build with linux" > $log_path 2>&1
    export TOP_V4F=$build_folder
    cd $TOP_V4F
    echo $TOP_V4F
    echo "build_V4A_l.sh ---> folder=$1 project=$2" >> $log_path 2>&1
    echo "Daily build start build 333" >> $log_path 2>&1
    echo `date` >> $log_path 2>&1
    if [ "$2" == "vcm31t210ref" ]; then
         echo "build_V4A_l.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf 
         export TOP=$(pwd)
         export TEGRA_TOP=$(pwd)
         export TARGET_PRODUCT=t210ref_int
         . tmake/scripts/envsetup.sh
         choose embedded-linux t210ref none release internal aarch64
         tmp 2>&1 | tee -a $log_path && tmp systemimage  2>&1 | tee -a $log_path
    elif [ "$2" == "vcm31t186ref" ]; then
         echo "build_V4A_l.sh special for vcm31t186ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf
         export TOP=$(pwd)
         export TEGRA_TOP=$(pwd)
         source tmake/scripts/envsetup.sh
         choose embedded-linux t186ref none release internal aarch64
         export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
         tmp 2>&1 | tee -a $log_path
         tmp systemimage  2>&1 | tee -a $log_path
         image create_rootfs | tee -a $log_path
    elif [ "$2" == "vcm31t186ref_int_k4" ]; then
         echo "build_V4A_l.sh special for vcm31t186ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf
         export TOP=$(pwd)
         export TEGRA_TOP=$(pwd)
         export TARGET_PRODUCT=t186ref_int
         . tmake/scripts/envsetup.sh
         choose embedded-linux t186ref none release internal aarch64
         tmp 2>&1 | tee -a $log_path && tmp systemimage  2>&1 | tee -a $log_path
    fi
fi
