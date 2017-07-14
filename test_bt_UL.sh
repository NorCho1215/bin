i=1
count=$1
delay_time=2
first_boot=$2

if [ "$#" -lt 2 ]; then
    echo "command: test_bt_UL.sh <how many runs> <system first boot Y/N>"
    echo "example: ./test_bt_UL.sh 10 Y"
    exit
else
  echo $first_boot
  if [ $first_boot == "Y" ]; then
    adb shell saf775x_util bootFromRom
    echo "please connect BT and make a call"
    sleep 10
  fi

  while [ "$i" != "$count" ]
  do
    echo "============ test $i runs"
    i=$(($i+1))
    time adb shell tinyplay /sdcard/mfile_48000_16_mono.wav -d 10 -c 1 -r 48000
    #sleep $delay_time
    time adb shell tinyplay /sdcard/wav_48khz_mono_16bit_1.wav -d 10 -c 1 -r 48000
    #sleep $delay_time
  done
  echo "end of test"
fi
