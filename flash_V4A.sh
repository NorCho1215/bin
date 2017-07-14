#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_V3A.sh <folder> <full/kernel> "
else

  Source_path="/home/ncho/1T/$1"
  echo Source_path=$Source_path
  cd $Source_path/foundation
  echo pwd=`pwd`
  export TOP_V4F=`pwd` && source tmake/scripts/envsetup.sh && choose embedded-foundation t210ref none release
  /home/ncho/bin/phidget-ctrl.sh recovery
  if [ "$2" == "kernel" ]; then
   echo "only flash kernel"
   ANDROID_BUILD_FLAVOR=release flash -a -b p2382a00 -u KERNEL_PRIMARY
  elif [ "$2" == "dtb" ]; then
   echo "only flash dtb"
   ANDROID_BUILD_FLAVOR=release flash -a -b p2382a00 -u DTB_PRIMARY
  else
   echo "flash all"
   sleep 3
   ANDROID_BUILD_FLAVOR=release flash -a -b p2382a00
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
