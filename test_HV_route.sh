#!/bin/bash
adb shell saf775x_util pset sec-out-r tdm0-in2
if [ "$1" == "1" ]; then
##==playback path
   echo "I2S4"
   adb shell tinymix -D 0 13 AMX1 #"I2S4 Mux" AMX1
   echo "AMX"
   adb shell tinymix -D 0 41 ADMAIF1 #"AMX1-1 Mux" ADMAIF1
   adb shell tinymix -D 0 42 ADMAIF5 #"AMX1-2 Mux" ADMAIF5
   adb shell tinymix -D 0 43 ADMAIF2 #"AMX1-3 Mux" ADMAIF2
   adb shell tinymix -D 0 44 ADMAIF6 #"AMX1-4 Mux" ADMAIF6
##==record path
   echo "ADMAIF"
   adb shell tinymix -D 0 0 ADX1-1 #"ADMAIF1 Mux" ADX1-1
   adb shell tinymix -D 0 1 ADX1-2 #"ADMAIF2 Mux" ADX1-3
   adb shell tinymix -D 0 4 ADX2-1 #"ADMAIF5 Mux" ADX1-1
   adb shell tinymix -D 0 5 ADX2-2 #"ADMAIF6 Mux" ADX1-4
   echo "ADX"
   adb shell tinymix -D 0 49 I2S3 #"ADX1 Mux" I2S4
   adb shell tinymix -D 0 50 I2S4 #"ADX2 Mux" I2S4
   #echo "radio"
   #adb shell tinymix -D 0 41 "ADX1-2" #"AMX1-1 Mux" ADX1-2

elif [ "$1" == "android" ]; then
   adb shell tinymix -D 0 13 "AMX1" #"I2S4 Mux" AMX
   adb shell tinymix -D 0 41 "ADX1-2" #"AMX1-1 Mux" ADMAIF1
else
   for ((i=0; i<=80; i=i+1))
   do
      adb shell tinymix -D 0 $i None
   done
fi
