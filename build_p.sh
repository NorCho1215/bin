#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"
export USE_CCACHE=1
export CCACHE_DIR=~/.ccache

Stream01=`ps aux |grep "make -C /home/" |grep -v grep |awk '{print $11}'`
i=0
echo stream=${Stream01}
while [ "${Stream01}" == "make" ]
do
   i=$(($i+1))
   Stream01=`ps aux |grep "make -C /home/" |grep -v grep |awk '{print $11}'`
   sleep 60
   Stream02=`ps aux |grep "make -C /home/" |grep -v grep |awk '{print $13}'`
   echo "$Stream02 build still running $i mins status=$Stream01" >> build_$1_$2.log 2>&1
done

project=$2
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/build_p.sh <folder> <project>"
else
    cd $code_path/$1 #for code folder
    echo "build_p.sh ---> folder=$1 project=$2" >> debug_script.log
    echo "Daily build start build 333" >> build_$1_$2.log 2>&1
    echo `date` >> build_$1_$2.log 2>&1
    if [ "$2" == "p1859ref" ]; then
         echo "build_p.sh special for p1859ref project ---> folder=$1 project=$2" >> debug_script.log
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         #export TOP=$(pwd) && . build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_$1.log 2>&1
         export TOP=$(pwd) &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_$1_$2.log 2>&1
    elif [ "$2" == "vcm31t210ref" ]; then
         echo "build_p.sh special for vcm31t210ref project ---> folder=$1 project=$2" >> debug_script.log
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         #export TOP=$(pwd) && . build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_$1.log 2>&1
         export TOP=$(pwd) && export SECURE_OS_BUILD=n &&. build/envsetup.sh && setpaths && choosecombo 1 $project 3 && mp dev >> build_$1_$2.log 2>&1
    else
         echo "build_p.sh special for common project ---> folder=$1 project=$2" >> debug_script.log
         prebuilts/misc/linux-x86/ccache/ccache -M 150G
         export TOP=$(pwd) &&. build/envsetup.sh && setpaths && unset ANDROID_HOME NDKROOT NDK_ROOT NDK_STANDALONE_46_ANDROID9_32 NDK_STANDALONE_46_ANDROID9_64 CUDA_TOOLKIT_ROOT CUDA_TOOLKIT_ROOT_7_0 GRADLE_HOME ANT_HOME && choosecombo 1 $project 3 && mp dev >> build_$1_$2.log 2>&1
    fi
fi
