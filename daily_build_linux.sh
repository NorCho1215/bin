#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"

PATH+=:$P4ROOT/sw/misc/linux/
echo $passww |sudo -S chown root $P4ROOT/sw/misc/linux/unix-build
echo $passww |sudo -S chmod u+s $P4ROOT/sw/misc/linux/unix-build
echo $passww |sudo -S chmod +x /home/ncho/Projects/upload/p4/sw/mobile/linux/distro/mobile_ldk/target_filesystem/ubuntu-core_trusty_hf_fullX11dev.tbz2

echo "Start build process"

if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/build_linux.sh <folder> <Y/N>"
else
    cd $code_path/$1 #for code folder
    echo "Daily build linux process start" > build_linux.log 2>&1
    echo `date` >> build_linux.log 2>&1
    echo "======rm out -rf & P4ROOT=$P4ROOT path=$code_path/$1======" >> build_linux.log 2>&1
    if [ "$2" == "Y" ]; then
       test -d $code_path/$1/.repo && echo $passww|sudo -S rm * -rf
       /usr/local/bin/repo sync -cj4
    else
       test -d $code_path/$1/.repo && echo $passww|sudo -S rm out -rf
    fi
    echo "======source tmake/scripts/envsetup.sh=======" >> build_linux.log 2>&1 
    echo "======source tmake/scripts/envsetup.sh======="
    source tmake/scripts/envsetup.sh >> build_linux.log 2>&1
    echo "====== choose embedded-linux vcm30t124 none release external x11 ======" >> build_linux.log 2>&1
    echo "====== choose embedded-linux vcm30t124 none release external x11 ======"
    choose embedded-linux vcm30t124 none release external x11 >> build_linux.log 2>&1
    echo "====== export NV_BUILD_CONFIGURATION_IS_VERBOSE=1 ======" >> build_linux.log 2>&1
    echo "====== export NV_BUILD_CONFIGURATION_IS_VERBOSE=1 ======"
    export NV_BUILD_CONFIGURATION_IS_VERBOSE=1 >> build_linux.log 2>&1
    echo "====== tmp ======" >> build_linux.log 2>&1
    echo "====== tmp ======"
    tmp >> build_linux.log 2>&1
    echo "====== tmp systemimage ======" >> build_linux.log 2>&1
    echo "====== tmp systemimage ======"
    tmp systemimage >> build_linux.log 2>&1
    echo "====== image create_rootfs ======" >> build_linux.log 2>&1
    echo "====== image create_rootfs ======"
    image create_rootfs >> build_linux.log 2>&1
    echo "====== ======" >> build_linux.log 2>&1
    echo "Daily build linux process end" >> build_linux.log 2>&1
    echo `date` >> build_linux.log 2>&1
fi
