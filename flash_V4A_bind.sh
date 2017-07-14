#!/bin/bash
board=$2
image_name=$3
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_V4A_SS.sh <folder> <board ES/INT > <full/kernel/ramdisk/dtb> "
else
  Source_path="/home/ncho/1T/$1"
  cd $Source_path/foundation
  rm out -rf 
  source tmake/scripts/envsetup.sh
  choose embedded-foundation t186ref none release
  source foundation/mk_blob.sh
  export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
  bind_partitions linux-qnx-android -b p2382-t186
  cd hypervisor/hypervisor-a15/tools/uart_muxer
  make
  cd ../../../../
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 6
#====================================
  if [ "$board" == "INT" ]; then
    
    echo "INT board"
    parameter="-M -H" 
   else
    echo "ES board"
    parameter="-H"
  fi
#===============================
  if [ "$image_name" == "kernel" ]; then
   echo "only flash kernel"
  elif [ "$image_name" == "ramdisk" ]; then
   echo "only flash ramdisk"
  elif [ "$image_name" == "dtb" ]; then
   echo "only flash dtb"
  elif [ "$image_name" == "hdmi_p" ]; then
   echo "only flash hdmi  primary dtb"
  else
   echo "flash all"
    ANDROID_BUILD_FLAVOR=release ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 $parameter
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
