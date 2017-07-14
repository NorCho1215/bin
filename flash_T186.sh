#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_V3A.sh <folder> <full/kernel> "
else

  Source_path="/home/ncho/1T/$1"
  echo Source_path=$Source_path
  cd $Source_path/foundation
  echo pwd=`pwd`
  export TOP_V4F=`pwd` && source tmake/scripts/envsetup.sh && choose embedded-foundation p2382-t186 none release
  /home/ncho/bin/phidget-ctrl.sh recovery
  if [ "$2" == "kernel" ]; then
   echo "flash only kernel"
   ANDROID_BUILD_FLAVOR=release flash -a -b p2382a00 -u KERNEL_PRIMARY
  else
   echo "flash all"
   sleep 10
   ANDROID_BUILD_FLAVOR=release flash -M -a -b p2382-t186
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
