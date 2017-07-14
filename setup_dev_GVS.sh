#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/setup_dev_GVS.sh <image_folder> <a_pid>"
else
image_folder=$1
a_pid=$2
test ! -d $image_folder && mkdir $image_folder
   cd $image_folder
   export TOP=$(pwd)
   if [ "$a_pid" != "Y" ]; then
      axel -n 40 http://buildbrain/mobile/virtual/main_android_vcm31t186ref_dev_git-master_notz_release/$a_pid/output.tgz -o output.android.tgz
   else
      mv output.android.tgz /tmp
      cd .. && rm $image_folder -rf && mkdir $image_folder && cd $image_folder && mv /tmp/output.android.tgz .
   fi
   test ! -f output.android.tgz && exit 1
   cp /home/ncho/1T/image/foundation_image/output.foundation.tgz.0304 ./output.foundation.tgz
   test ! -f output.foundation.tgz && exit 1
   mkdir vibrante-t186ref-android
   cd vibrante-t186ref-android
   tar -zxf ../output.android.tgz
   cd $TOP
   tar -zxf output.foundation.tgz
   pdk_setup=`ls * |grep pdk`
   ./$pdk_setup
   /home/ncho/bin/phidget-ctrl.sh recovery
   cd $TOP/vibrante-t186ref-foundation
   ANDROID_BUILD_FLAVOR=release NV_GIT_TOP=$PWD/../sanity ./utils/scripts/bootburn/bootburn.sh -a -b p2382-t186 -M
   /home/ncho/bin/phidget-ctrl.sh reset
fi
