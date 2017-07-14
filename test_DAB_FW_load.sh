#!/bin/bash
if [ "$#" -lt 2 ]; then
    echo "command: test_early_camera.sh <FILE_NAME> <count>"
    exit 0
fi
sw_path="/home/ncho/Projects/upload/Nvbug/Radio/saturn_sabre/SAF36xx_REL_DAB_CR7.3.12/SAF36xx_REL_DAB_CR7.3.12/DAB_sw"
FILE_NAME=$1
k=0
count=$2
var=("ad" "80" "00" "06" "00" "01" "00" "f3" "03" "0f" "ae" "7b")

function check_read_var(){
  START=$(date +%s)
  adb shell /system/vendor/bin/saf36xx_util load /system/vendor/firmware/SAF36xx_DAB.bin > $FILE_NAME 2>&1
  END=$(date +%s)
  DIFF=$(( $END - $START ))
  echo "It took $DIFF seconds  END=$END START=$START"
  exec < $FILE_NAME
  while read line
  do 
     Stream_read=`echo $line|awk '{print $1}'|tr -d '\r'`
     reg_read=`echo ${var[$(($i-j))]}|awk '{print $1}'|tr -d '\r'`
     if [ "$Stream_read" == "Reading" ]; then
           j=$(($i+1))
     fi
     ## For debug
     #if [ "$j" != "0" ]; then
     #      echo "111 ${Stream_read}=${reg_read}"
     #fi
     if [ "$i" -gt "$j" ] && [ "$j" != "0" ]; then
           if [ "$Stream_read" != "$reg_read" ]; then
               echo "333 Stream_read=$Stream_read"
               echo "444 var=$reg_read"
               echo "555 error in $k times i=$i j=$j"
               exit -1
           fi 
     fi
     i=$(($i+1))
  done
}
adb wait-for-device
adb remount 
adb push $sw_path/SAF36xx_DAB_CR7.3.12_20150423_1515_retail_sf3_RefSetup_RFE_RI_VS_vg_cs10-13_encNXD.bin /system/vendor/firmware/SAF36xx_DAB.bin
## main
while [ "$k" != "$count" ]
do
  i=0
  j=0
  echo "check_read_var +$k+"
  check_read_var;
  echo "check_read_var --"
  k=$(($k+1))
done
#while [ "$i" != "12" ]
#do
#  echo "var=${var[$i]}"
#  i=$(($i+1))
#done

exit 0


if [ "$#" -lt 2 ]; then
    echo "command: test_early_camera.sh <FILE_NAME> <count>"
    exit 0
fi
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "test count =$i"
 adb wait-for-device
 echo "video mode"
 adb shell echo "=================Test count=$i ========================">>test_early_camera_log_$FILE_NAME.log 2>&1
 adb shell cat proc/kmsg |grep early >> test_early_camera_log_$FILE_NAME.log &
 sleep 15
 adb shell ps |grep early
 Stream01=`adb shell ps |grep nvmedia_earlyca |awk '{print $8}'` ### |cut -d '/' -f 4`
 echo ${Stream01}
 if [ "${Stream01}" != "R" ];then
   echo "error Get nvmedia_earlycamera problem"
   exit -1;
 fi
 echo "rear camera"
 adb reboot
done
