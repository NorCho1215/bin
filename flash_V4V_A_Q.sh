#!/bin/bash
board=$2
image_name=$3
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/flash_V4V_A_Q.sh <folder> <board ES/INT > <full/kernel> "
else
  Source_path="/home/ncho/1T/$1"
  echo Source_path=$Source_path
  cd $Source_path/foundation
  echo pwd=`pwd`
  source tmake/scripts/envsetup.sh && choose embedded-foundation t186ref none release && source foundation/mk_blob.sh && export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
  rm out -rf 
  tmp
  tmp systemimage
  echo "PWD=`pwd`"
  export TOP_V4F=`pwd` && bind_partitions android-qnx -b p2382-t186
  cd hypervisor/hypervisor-a15/tools/uart_muxer
  make
  cd $TOP_V4F
  /home/ncho/bin/phidget-ctrl.sh recovery
  sleep 10
#====================================
  if [ "$board" == "ES" ]; then
    echo "ES board"
    parameter="-H"
   else
    echo "INT board"
    parameter="-M -H"
  fi
#===============================

  if [ "$image_name" == "kernel" ]; then
   echo "only flash kernel"
   export TOP_V4F=`pwd` && ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 -u KERNEL_PRIMARY $parameter
  else
     echo "flash all"
     ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 $parameter
     #export TOP_V4F=`pwd` && ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 $parameter
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
