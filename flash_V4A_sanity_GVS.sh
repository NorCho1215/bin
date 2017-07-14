#!/bin/bash
board=$2
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/flash_V3A.sh <folder> <board ES/INT > <full/kernel> "
else
  test ! -d out/ && tar -xvjf tests_output.tbz2
  echo pwd=`pwd`
  /home/ncho/bin/phidget-ctrl.sh recovery
#====================================
  if [ "$board" == "ES" ]; then
    echo "ES board"
    parameter="-L"
   else
    echo "INT board"
    parameter="-M -L"
  fi
#===============================
  sleep 6
  if [ "$1" == "kernel" ]; then
   echo "only flash kernel"
   TEST_AUTOMATION=1 ./flash.sh $parameter -u KERNEL_PRIMARY
  elif [ "$1" == "dtb" ]; then
   echo "only flash dtb"
   TEST_AUTOMATION=1 ./flash.sh $parameter -u DTB_PRIMARY
  else
   echo "flash all"
   TEST_AUTOMATION=1 ./flash.sh $parameter
  fi
  /home/ncho/bin/phidget-ctrl.sh reset
fi
