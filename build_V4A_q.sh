#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"
folder=$1
project=$2
log_path=$code_path/$1/qnx/build_$1_$2.log
build_folder=$code_path/$folder/qnx
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/build_V4A_q.sh <folder> <project>"
    echo "e.g. /home/ncho/bin/build_V4A_q.sh V4A_Alpha2 vcm31t186ref"
else
    echo "start build with foundation" > $log_path 2>&1
    export TOP_V4Q=$build_folder
    cd $TOP_V4Q
    echo $TOP_V4Q
    echo "build_V4A_q.sh ---> folder=$1 project=$2" >> $log_path 2>&1
    echo "Daily build start build 333" >> $log_path 2>&1
    echo `date` >> $log_path 2>&1
    if [ "$2" == "vcm31t210ref" ]; then
         echo "build_V4A_f.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf 
         source tmake/scripts/envsetup.sh && choose embedded-foundation t210ref none release && tmp >> $log_path 2>&1
    elif [ "$2" == "vcm31t186ref" ]; then
         echo "build_V4A_f.sh special for vcm31t186ref project ---> folder=$1 project=$2" >> $log_path 2>&1
         test -d .repo && rm out -rf
         source tmake/scripts/envsetup.sh
	choose embedded-qnx t186ref none release external
	#choose embedded-qnx t186ref none release internal
	export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
        echo "=========================tmp" >> $log_path &&
	tmp 2>&1 | tee -a $log_path &&
        echo "=========================tmp systemimage" >> $log_path &&
	tmp systemimage 2>&1 | tee -a $log_path &&
        #echo "=========================image delete_rootfs" >> $log_path
        #image delete_rootfs 2>&1 | tee -a $log_path &&
        echo "=========================image create_rootfs" >> $log_path &&
	image create_rootfs 2>&1 | tee -a $log_path 
        cp out/embedded-qnx-t186ref-release-none/nvidia/qnx-bsp/bsp/armv8/images/ifs-nvidia-t18x-vcm31t186-vmserver.bin ../foundation/foundation/vm-server/t18x-vm-server.bin
    fi
fi
