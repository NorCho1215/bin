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
    source tmake/scripts/envsetup.sh >> build_linux.log 2>&1
    echo "====== choose embedded-linux vcm30t124 none release external x11 ======" >> build_linux.log 2>&1
    choose embedded-linux vcm30t124 none release external x11 >> build_linux.log 2>&1
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
    echo "Daily build linux process end"
    echo $passww|sudo -S cp -rf /home/ncho/Projects/upload/Nvbug/EAVB/patch/test/p2p-demo $TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/
    echo $passww|sudo -S cp /home/ncho/Projects/upload/video/220_20s.pcm $TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/p2p-demo
    echo $passww|sudo -S cp /home/ncho/bin/setup_linux.sh $TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/p2p-demo
    echo $passww|sudo -S cp /home/ncho/1T/linux/3rdparty/pelagicore/scripts $TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/
    cd $TEGRA_TOP/3rdparty/pelagicore/nvidia-grayson-drivers/core_drv
    make ARCH=arm  LOCALVERSION="" CROSS_COMPILE=$P4ROOT/sw/embedded/tools/toolchains/linaro-4_7-2013q1/bin/arm-none-eabi- -C $TEGRA_TOP/out/embedded-linux-vcm30t124-release/nvidia/kernel M=$TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/p2p-demo >> build_linux.log 2>&1
    cd $TEGRA_TOP/3rdparty/pelagicore/nvidia-grayson-drivers/i2c_drv
    make ARCH=arm  LOCALVERSION="" CROSS_COMPILE=$P4ROOT/sw/embedded/tools/toolchains/linaro-4_7-2013q1/bin/arm-none-eabi- -C $TEGRA_TOP/out/embedded-linux-vcm30t124-release/nvidia/kernel M=$TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/p2p-demo >> build_linux.log 2>&1
    cd $TEGRA_TOP/3rdparty/pelagicore/nvidia-grayson-drivers/usb_drv
    make ARCH=arm  LOCALVERSION="" CROSS_COMPILE=$P4ROOT/sw/embedded/tools/toolchains/linaro-4_7-2013q1/bin/arm-none-eabi- -C $TEGRA_TOP/out/embedded-linux-vcm30t124-release/nvidia/kernel M=$TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/p2p-demo >> build_linux.log 2>&1
    echo `date` >> build_linux.log 2>&1
fi
