#!/bin/bash
if [ "$#" -lt 6 ]; then
    echo "command: ~/bin/flash_V4A_cust_GVS.sh <version> <platform> <download Y/N> <android_gid> <foundation_gid> <build_gcid>"
    echo "e.g. ~/bin/flash_V4A_cust_GVS.sh 25.05.03 t186ref Y 18045902 18045897 6656274"
    echo "e.g. ~/bin/flash_V4A_cust_GVS.sh 25.05.03 t186ref N 18045902 18045897 6656274"
else
  version=$1
  platform=$2
  download=$3
  android_gid=$4
  foundation_gid=$5
  build_gcid=$6
  if [ "$download" == "Y" ]; then 
    axel -n 40 http://buildbrain/mobile/automatic/embedded-${version}_android_vcm31${platform}_cust-standard_git-master_notz_release/${android_gid}/customerBuildOutput.release.tgz -o output.android.tgz
    axel -n 40 http://buildbrain/mobile/automatic/embedded-${version}_embedded-foundation_${platform}_none_git-master_none_release/${foundation_gid}/output.tgz -o output.foundation.tgz
  fi
  mkdir vibrante-${platform}-android
  cd vibrante-${platform}-android
  tar -zxf ../output.android.tgz
  ./flash.sh
  cd ..
  tar -zxvf output.foundation.tgz
  ./vibrante-${platform}-foundation-${version}-${build_gcid}-release-pdk.run 
  cd vibrante-t186ref-foundation
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 5
  ANDROID_BUILD_FLAVOR=release NV_GIT_TOP=$PWD/../sanity ./utils/scripts/bootburn/bootburn.sh -a -b p2382-t186 -M
  /home/ncho/bin/phidget-ctrl.sh reset
fi
