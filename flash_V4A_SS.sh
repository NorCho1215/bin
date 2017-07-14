#!/bin/bash
board=$2
image_name=$3
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_V4A_SS.sh <folder> <board ES/INT > <full/kernel/ramdisk/dtb/adsp-fw> "
else
  Source_path="/home/ncho/1T/$1"
  echo Source_path=$Source_path
  cd $Source_path/foundation
  echo pwd=`pwd`
  export TOP_V4F=`pwd` && source tmake/scripts/envsetup.sh && choose embedded-foundation t186ref none release
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 6
#====================================
  if [ "$board" == "INT" ]; then
    
    echo "INT board"
    parameter="-M -a -b" 
   else
    echo "ES board"
    parameter="-a -b"
  fi
#===============================
  if [ "$image_name" == "kernel" ]; then
   echo "only flash kernel"
   ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -u kernel -L
  elif [ "$image_name" == "ramdisk" ]; then
   ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -u ramdisk -L
  elif [ "$image_name" == "adsp-fw" ]; then
   ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -u adsp-fw -L
  elif [ "$image_name" == "dtb" ]; then
   echo "only flash dtb"
   ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -d DTB_PRIMARY tegra186-vcm31-p2382-010-a01-00-base.dtb -L
  elif [ "$image_name" == "hdmi_p" ]; then
   echo "only flash hdmi  primary dtb"
   ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -d DTB_PRIMARY tegra186-vcm31-p2382-010-a01-00-hdmi-primary.dtb -L
  else
   echo "flash all"
    ANDROID_BUILD_FLAVOR=release flash $parameter p2382-t186 -L
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
