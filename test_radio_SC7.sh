#!/bin/bash
i=0
j=0
x=20 #dP=10
y=400 #dp=300
count=$1
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/test_radio_SC7.sh <count>"
    exit 0
fi

phidget-ctrl.sh reset
sleep 60
adb shell '/system/bin/log -t "Nor debug" -p i "Step 1: turn on Tuner app ++"'
adb shell "am start tuner.tunerapp/.MainActivity"
adb shell '/system/bin/log -t "Nor debug" -p i "Step 1: turn on Tuner app --"'
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "==========test count =$i======================="
 adb shell '/system/bin/log -t "Nor debug" -p i "=================Test count=$i ========================"'
 echo "Step 2 : mute radio"
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 2: mute radio ++"'
 adb shell input tap $x $y #mute
 adb shell 'tinymix "I2S3 Mux" "None"'
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 2: mute radio --"'
 sleep 5
 echo "Step 3 : enter SC7"
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 3: enter SC7 ++"'
 phidget-ctrl.sh on ## suspend
 sleep 10
#================================
 a="1"
 while [ "$a" == "1" ]
 do
    a="0"
    adb devices |grep -n 1 && a="1" && echo "system don't into Sc7"
    adb shell dmesg -c |grep "I2S2_TX" && exit 1
    if [ "$a" == "1" ]; then
        phidget-ctrl.sh on
        adb shell input tap $x $y
        sleep 10
    fi
    echo "a=$a"
 done
#======================
 sleep 5
 phidget-ctrl.sh on ## resume
 echo "Step 4 : exit the SC7"
 adb wait-for-device
 sleep 1
 adb -d shell am broadcast -a android.intent.action.SCREEN_ON
 adb shell 'tinymix "I2S3 Mux" "AMX1"'
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 4: exit SC7 --"'
 echo "Step 5: screen on / radio on"
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 5: check the audio status --"'
 adb shell dmesg | grep -E "link training" | tail -n 1
 for (( k=1; k<=15; k=k+1))
 do
   adb shell dmesg | grep -E "link training" | tail -n 1
   sleep 1
   adb shell dmesg |grep "I2S2_TX" && exit 1
 done
 adb shell dmesg -c |grep tegra210-i2s 
 adb shell dmesg -c |grep "I2S2_TX" && exit 1
 echo "Step 6: goto Step2"
done
