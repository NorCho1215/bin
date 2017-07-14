folder=$1
mkdir $folder
cd $folder
if [ "$#" -lt 1 ]; then
    echo "command: flash_3OS_GVS.sh <folder>"
else

    export BB=$(pwd)
    cd ../foundation
    tar -zxf output.tgz
    cd ../linux
    tar -zxf output.tgz
    cd ../qnx
    tar -zxf output.tgz
############################11111111
    cd $BB
    mkdir vibrante-t186ref-android
    tar -zxf ../android/output.tgz -C vibrante-t186ref-android
###########################22222222
    `find ../qnx |grep qnx-toolchain`
    mv toolchains qnx_toolchains
    `find ../qnx |grep driver`
    `find ../../toolchain/ |grep toolchain`
    `find ../foundation/ |grep release-pdk`
    `find ../linux/ |grep xenial-ubuntu`
    `find ../linux/ |grep yocto.run`
    `find ../linux/ |grep oss-minimal-pdk.run`
    `find ../linux/ |grep nv-minimal-pdk.run`
    cd vibrante-t186ref-foundation
    make -f Makefile.bind PCT=linux-qnx-android
    phidget-ctrl.sh recovery
    ANDROID_BUILD_FLAVOR=release ANDROID_TARGET_DEVICE=vcm31t186 ./utils/scripts/bootburn/bootburn.sh -H -b p2382-t186
fi
