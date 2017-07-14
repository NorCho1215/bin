#!/bin/bash
i=0
j=0
count=$1
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/test_audio_SC7.sh <count>"
    exit 0
fi

function init_d3(){
	echo "Your choice is ${1}"
        if [ "${1}" == "init" ]; then

             adb shell '/system/bin/log -t "Nor debug" -p i " init_AHUB ++"'
             # initialize dirana3
             adb shell saf775x_util bootFromRom

             #enable SRC
             adb shell saf775x_util vset src0-set 0x800000
             adb shell saf775x_util vset src1-set 0x800000
             adb shell saf775x_util vset src4-set 0x800000

             #enable tdm1 as primary input
             adb shell saf775x_util pset tdm1-out pri-input

             #enable swdac output
             adb shell saf775x_util pset front-out-l swdac-in

             #enable radio output
             adb shell saf775x_util pset sec-out-r tdm0-in2

             #enable adc01 as secondary2 input
             adb shell saf775x_util pset an01-out sec2-input
             adb shell saf775x_util pset sec2-out-r tdm0-in1

             #enable src0outpntr as bt uplink
             adb shell saf775x_util pset sec2-out  bt-input

             #enable i2s2 as secondary input
             adb shell saf775x_util pset i2s2-out sec-input
             adb shell saf775x_util pset sec-out tdm0-in2

             #Set adc0, adc1 to mode 4
             adb shell saf775x_util cset adc0-conf 4
             adb shell saf775x_util cset adc1-conf 4
             adb shell saf775x_util cset adc2-conf 2
             adb shell saf775x_util cset adc3-conf 2
             adb shell saf775x_util cset adc4-conf 2
             adb shell saf775x_util cset adc5-conf 2
             adb shell saf775x_util cset adcen-conf 0

             #volume and mute setting
             adb shell saf775x_util vset pri-mute 0x07ff
             adb shell saf775x_util vset pri-vol1 0x00ff
             adb shell saf775x_util vset pri-vol2 0x0080

             adb shell saf775x_util vset sec-mute 0x07ff
             adb shell saf775x_util vset sec-vol1 0x00ff
             adb shell saf775x_util vset sec-vol2 0x0653

             adb shell saf775x_util vset sec2-mute 0x07ff
             adb shell saf775x_util vset sec2-vol1 0x07ff
             adb shell saf775x_util vset sec2-vol2 0x07ff


             adb shell 'tinymix "AMX1-2 Mux" "ADMAIF2"'
             adb shell 'tinymix "AMX1-3 Mux" "ADMAIF3"'
             adb shell 'tinymix "AMX1-4 Mux" "ADMAIF4"'
             adb shell 'tinymix "ADMAIF1 Mux" "ADX1-1"'
             adb shell 'tinymix "ADMAIF2 Mux" "ADX1-2"'
             adb shell 'tinymix "ADMAIF3 Mux" "ADX1-3"'
             adb shell 'tinymix "ADMAIF4 Mux" "ADX1-4"'
             adb shell 'tinymix "ADX1 Mux" "I2S3"'

             adb shell 'tinymix "AMX2-1 Mux" "ADMAIF5"'
             adb shell 'tinymix "AMX2-2 Mux" "ADMAIF6"'
             adb shell 'tinymix "AMX2-3 Mux" "ADMAIF7"'
             adb shell 'tinymix "AMX2-4 Mux" "ADMAIF8"'
             adb shell 'tinymix "I2S4 Mux" "AMX2"'
             adb shell 'tinymix "ADMAIF5 Mux" "ADX2-1"'
             adb shell 'tinymix "ADMAIF6 Mux" "ADX2-2"'
             adb shell 'tinymix "ADMAIF7 Mux" "ADX2-3"'
             adb shell 'tinymix "ADMAIF8 Mux" "ADX2-4"'
             adb shell 'tinymix "ADX2 Mux" "I2S4"'

             adb shell 'tinymix "I2S3 Mux" "AMX1"'
             adb shell 'tinymix "AMX1-1 Mux" "MIXER1-1"'
             adb shell 'tinymix "MIXER1-1 Mux" "ADMAIF1"'
             adb shell 'tinymix "MIXER1-2 Mux" "SFC1"'
             adb shell 'tinymix "Adder1 RX1" "1"'
             adb shell 'tinymix "Adder1 RX2" "1"'
             adb shell 'tinymix "Mixer Enable" "1"'

             adb shell '/system/bin/log -t "Nor debug" -p i " init_AHUB --"'
        elif [ "${1}" == "deinit" ]; then
             adb shell '/system/bin/log -t "Nor debug" -p i " de init_AHUB ++"'
             adb shell 'tinymix "Mixer Enable" "0"'
             adb shell 'tinymix "Adder1 RX1" "0"'
             adb shell 'tinymix "Adder1 RX2" "0"'
             adb shell 'tinymix "I2S3 Mux" "None"'
             adb shell 'tinymix "AMX1-1 Mux" "None"'
             adb shell 'tinymix "MIXER1-1 Mux" "None"'
             adb shell 'tinymix "MIXER1-2 Mux" "None"'

             adb shell 'tinymix "AMX1-2 Mux" "None"'
             adb shell 'tinymix "AMX1-3 Mux" "None"'
             adb shell 'tinymix "AMX1-4 Mux" "None"'
             adb shell 'tinymix "ADMAIF1 Mux" "None"'
             adb shell 'tinymix "ADMAIF2 Mux" "None"'
             adb shell 'tinymix "ADMAIF3 Mux" "None"'
             adb shell 'tinymix "ADMAIF4 Mux" "None"'
             adb shell 'tinymix "ADX1 Mux" "None"'

             adb shell 'tinymix "AMX2-1 Mux" "None"'
             adb shell 'tinymix "AMX2-2 Mux" "None"'
             adb shell 'tinymix "AMX2-3 Mux" "None"'
             adb shell 'tinymix "AMX2-4 Mux" "None"'
             adb shell 'tinymix "I2S4 Mux" "None"'
             adb shell 'tinymix "ADMAIF5 Mux" "None"'
             adb shell 'tinymix "ADMAIF6 Mux" "None"'
             adb shell 'tinymix "ADMAIF7 Mux" "None"'
             adb shell 'tinymix "ADMAIF8 Mux" "None"'
             adb shell 'tinymix "ADX2 Mux" "None"'
             adb shell '/system/bin/log -t "Nor debug" -p i " de init_AHUB --"'
        elif [ "${1}" == "check" ]; then
             adb shell '/system/bin/log -t "Nor debug" -p i "`tinymix |grep I2S3`"'
        fi 
}

phidget-ctrl.sh reset
sleep 60
init_d3 init
while [ "$i" != "$count" ]
do
 i=$(($i+1))
 echo "test count =$i"
 string1="=================Test count=${i} ========================"
 adb shell "/system/bin/log -t 'Nor debug' -p i ${string1}"
 echo "Step 2"
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 1: playback music 5 secs and stop music also back to home ++"'
 adb shell am start -a android.intent.action.View -d "file:///sdcard/Kokoniiruyo.mp3" -n "com.android.music/.MediaPlaybackActivity"
 sleep 5
 adb shell input keyevent 85 ## stop music playback
 sleep 1
 adb shell input keyevent 3 ## home key
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 1: playback music 5 secs and stop music also back to home --"'
 sleep 5
 echo "Step 3"
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 2: enter SC7 ++"'
 adb devices |grep -n 1 && init_d3 deinit
 adb devices |grep -n 1 && init_d3 check
 sleep 5
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
        adb shell '/system/bin/log -t "Nor debug" -p i "Step 2: enter SC7 again due to system dont into SC7++"'
        adb devices |grep -n 1 && init_d3 deinit
        adb devices |grep -n 1 && init_d3 check
        sleep 5
        phidget-ctrl.sh on
        sleep 10
    fi
    echo "a=$a"
 done
#======================
 sleep 10
 phidget-ctrl.sh on ## resume
 sleep 1
 adb wait-for-device
 sleep 1
 adb -d shell am broadcast -a android.intent.action.SCREEN_ON
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 3: exit SC7 --"'
 sleep 15
#================================
 a="0"
 while [ "$a" == "0" ]
 do
    a="0"
    adb devices |grep -n 1 && a="1" && echo "system already wake up"
    adb shell dmesg -c |grep "I2S2_TX" && exit 1
    if [ "$a" == "0" ]; then
        adb shell '/system/bin/log -t "Nor debug" -p i "Step 3: Step 3: exit SC7 again due to system dont wake up normally--"'
        phidget-ctrl.sh on
        sleep 10
    fi
    echo "a=$a"
 done
#======================
 echo "Step 4"
 adb devices |grep -n 1 && init_d3 check
 adb devices |grep -n 1 && init_d3 init
 adb devices |grep -n 1 && init_d3 check
 adb shell '/system/bin/log -t "Nor debug" -p i "Step 4: check the audio status --"'
 adb shell dmesg -c |grep "I2S2_TX" && exit 1
 echo "goto Step2"
done
