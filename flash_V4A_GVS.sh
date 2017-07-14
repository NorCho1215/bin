#!/bin/bash
folder=$1
release=$2
board=$3
platform=t186ref
if [ "$board" == "ES" ]; then
   ppp="-L"
else
   ppp="-M -L"
fi
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/flash_V4A_GVS.sh <folder> <release/debug> <board- ES/INT>"
else
  mkdir $folder
  cd $folder
  mkdir vibrante-${platform}-android
  cd vibrante-${platform}-android
  tar -zxf ../../output.android.tgz
  cd ..
  tar -zxvf ../output.foundation.tgz
  a=`ls |grep pdk`
  ./$a
  cd vibrante-t186ref-foundation
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 8
  ANDROID_BUILD_FLAVOR=$release NV_GIT_TOP=$PWD/../sanity ./utils/scripts/bootburn/bootburn.sh -a -b p2382-t186 $ppp
  /home/ncho/bin/phidget-ctrl.sh reset
fi
