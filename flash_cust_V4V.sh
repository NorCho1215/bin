#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_cust_V4V.sh <folder>"
    echo "e.g. : /home/ncho/bin/flash_cust_V4V.sh test"
else
  path=`pwd`
  test ! -f customerBuildOutput.release.tgz && echo "no android image ~~ customerBuildOutput.release.tgz" && exit -1 
  test ! -f output.tgz && echo "no foundation image ~~ output.tgz" && exit -1
  toolchain_command=`ls |grep toolchain`
  echo $toolchain_command
  test ! -f $toolchain_command && echo "no toolchain image ~~ vibrante-t186ref-foundation-xxxx-xxxx-toolchain.run" && exit -1
  rm $1 -rf
  mkdir -p $1/vibrante-t186ref-android
  cd $1/vibrante-t186ref-android
  tar -zxf ../../customerBuildOutput.release.tgz
  ./flash.sh
  cd ..
  ../$toolchain_command
  tar -zxf ../output.tgz
  pdk_command=`ls |grep pdk`
  ./$pdk_command
  cd vibrante-t186ref-foundation
  make -f Makefile.bind PCT=android
  /home/ncho/bin/phidget-ctrl.sh recovery
  ANDROID_TARGET_DEVICE=vcm31t186 ANDROID_BUILD_FLAVOR=release NV_GIT_TOP=$PWD/../sanity ./utils/scripts/bootburn/bootburn.sh -H -b p2382-t186 -M
  /home/ncho/bin/phidget-ctrl.sh reset
fi
