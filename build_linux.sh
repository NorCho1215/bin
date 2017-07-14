#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"

PATH+=:$P4ROOT/sw/misc/linux/
echo $passww|sudo -S chown root $P4ROOT/sw/misc/linux/unix-build
echo $passww|sudo -S chmod u+s $P4ROOT/sw/misc/linux/unix-build
echo $passww|sudo -S chmod +x /home/ncho/Projects/upload/p4/sw/mobile/linux/distro/mobile_ldk/target_filesystem/ubuntu-core_trusty_hf_fullX11dev.tbz2

if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/build_linux.sh <folder>"
else
    cd $code_path/$1 #for code folder
    echo "Daily build linux process start" > build_linux.log 2>&1
    echo `date` >> build_linux.log 2>&1
    echo "======rm out -rf & P4ROOT=$P4ROOT path=$code_path/$1======" >> build_linux.log 2>&1
    test -d $code_path/$1/.repo && rm out -rf
    echo "======source tmake/scripts/envsetup.sh=======" >> build_linux.log 2>&1 
    export ARMLMD_LICENSE_FILE=1924@sc-lic-18:1924@sac-lic-19
    export TOP=$(pwd)
    export TEGRA_TOP=$(pwd)
    export TARGET_PRODUCT=t186ref_int
    source tmake/scripts/envsetup.sh >> build_linux.log 2>&1
    echo "====== choose embedded-linux vcm30t124 none release external x11 ======" >> build_linux.log 2>&1
    choose embedded-linux t186ref none release external x11 >> build_linux.log 2>&1
    echo "====== export NV_BUILD_CONFIGURATION_IS_VERBOSE=1 ======" >> build_linux.log 2>&1
    export NV_BUILD_CONFIGURATION_IS_VERBOSE=1 >> build_linux.log 2>&1
    echo "====== tmp ======" >> build_linux.log 2>&1
    tmp >> build_linux.log 2>&1
    echo "====== tmp systemimage ======" >> build_linux.log 2>&1
    tmp systemimage >> build_linux.log 2>&1
    echo "====== image create_rootfs ======" >> build_linux.log 2>&1
    image create_rootfs >> build_linux.log 2>&1
    echo "====== ======" >> build_linux.log 2>&1
    echo "Daily build linux process end" >> build_linux.log 2>&1
    echo `date` >> build_linux.log 2>&1
fi
