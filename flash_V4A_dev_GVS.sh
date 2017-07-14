#!/bin/bash
if [ "$#" -lt 7 ]; then
    echo "command: ~/bin/flash_V4A_dev_GVS.sh <release/debug> <version> <platform> <download Y/N> <android_gid> <foundation_gid> <build_gcid>"
    echo "e.g. ~/bin/flash_V4A_dev_GVS.sh release 25.05.03 t186ref Y 18045902 18045897 6656274"
    echo "e.g. ~/bin/flash_V4A_dev_GVS.sh release 25.05.03 t186ref N 18045902 18045897 6656274"
else
  release=$1
  version=$2
  platform=$3
  download=$4
  android_gid=$5
  foundation_gid=$6
  build_gcid=$7
  if [ "$download" == "Y" ]; then 
    axel -n 40 http://buildbrain/mobile/virtual/main_android_vcm31${platform}_int_dev_git-master_notz_${release}/${android_gid}/output.tgz -o output.android.tgz
    axel -n 40 http://buildbrain/mobile/virtual/main_embedded-foundation_${platform}_none_git-master_none_release/${foundation_gid}/output.tgz -o output.foundation.tgz
  fi
  mkdir vibrante-${platform}-android
  cd vibrante-${platform}-android
  tar -zxf ../output.android.tgz
  cd ..
  tar -zxvf output.foundation.tgz
  exit -1 ##debug
  ./vibrante-${platform}-foundation-${version}-${build_gcid}-release-pdk.run 
  cd vibrante-t186ref-foundation
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 5
  NDROID_BUILD_FLAVOR=${release} NV_GIT_TOP=$PWD/../sanity ./utils/scripts/bootburn/bootburn.sh -a -b p2382-t186 -M
  /home/ncho/bin/phidget-ctrl.sh reset
fi
