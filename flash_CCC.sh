#!/bin/bash
board=$3
image_bind=$2
partation_name=$4
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/flash_V4A_SS.sh <folder> <HA/HL/A/LQA> <board ES/INT > <3_kernel/3_kernel-dtb>"
    echo "3_kernel: android kernel"
    echo "flash_V4V.sh rel-25 LQA ES 3_kernel-dtb"
else
  Source_path="/home/ncho/1T/$1"
  /home/ncho/bin/disable_adbmouse.sh
  cd $Source_path/foundation
  test -d .repo && rm out -rf
  export TOP=$(pwd)
  export TEGRA_TOP=$(pwd)
  export TOOLCHAIN_PREFIX=arm-none-eabi-
  export TARGET_PRODUCT=t186ref_int
  export TOP_V4F=`pwd` && source tmake/scripts/envsetup.sh && choose embedded-foundation t186ref none release
  source foundation/mk_blob.sh
  export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
  tmp && tmp systemimage
  if [ "$image_bind" == "HA" ]; then
      bind_partitions android -b p2382-t186
  elif [ "$image_bind" == "A" ]; then
      echo "native android"
  elif [ "$image_bind" == "L" ]; then
      echo "native linux"
  elif [ "$image_bind" == "HL" ]; then
      bind_partitions linux -b p2382-t186
  elif [ "$image_bind" == "LQA" ]; then
      bind_partitions linux-qnx-android -b p2382-t186
      cd hypervisor/hypervisor-a15/tools/uart_muxer
      make
      cd ../../../../
  fi
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 15
  if [ "$board" == "INT" ]; then
    echo "INT board"
    parameter="-M -H" 
   else
    echo "ES board"
    parameter="-H"
  fi
#====================================

#===============================
  echo "flash all"
  if [ "$image_bind" == "A" ]; then
      ANDROID_BUILD_FLAVOR=release flash -a -b p2382-t186 -L
  elif [ "$image_bind" == "L" ]; then
      ANDROID_BUILD_FLAVOR=release flash -b p2382-t186
  else
      if [ "$partation_name" == "" ]; then
          ANDROID_BUILD_FLAVOR=release ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 $parameter
      else
          ANDROID_BUILD_FLAVOR=release ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 $parameter -u $partation_name
      fi
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
