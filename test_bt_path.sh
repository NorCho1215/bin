#!/bin/bash
#/* downlink path */
adb shell tinymix -D 0 "ASRC1 Ratio3 SRC" "ARAD"
adb shell tinymix -D 0 "Numerator3 Mux" "I2S6"
adb shell tinymix -D 0 "Denominator3 Mux" "I2S3"
adb shell tinymix -D 0 "I2S3 Mux" "AMX1"
adb shell tinymix -D 0 "AMX1-1 Mux" "ASRC1-3"
echo 1111

#/* uplink path */ 
adb shell tinymix -D 0 "ASRC1 Ratio2 SRC" ARAD
adb shell tinymix -D 0 "Numerator2 Mux" I2S3
adb shell tinymix -D 0 "Denominator2 Mux" I2S6
adb shell tinymix -D 0 "ADX1 Mux" "I2S3"
adb shell tinymix -D 0 "ASRC1-2 Mux" "ADX1-1"
echo 2222
adb shell tinymix -D 0 "I2S6 Mux" "ASRC1-2"
adb shell tinymix -D 0 "ASRC1-3 Mux" "I2S6"
echo 3333
#/*arad lane enable */
adb shell tinymix -D 0 "ASRC1-7 Mux" ARAD1
adb shell tinymix -D 0 "Lane2 enable" 1
adb shell tinymix -D 0 "Lane3 enable" 1
echo 444
if [ "$1" == "disable" ]; then
#disconnect command
adb shell tinymix -D 0 "ASRC1-2 Mux" None
adb shell tinymix -D 0 "ASRC1-3 Mux" None
adb shell tinymix -D 0 "ASRC1-7 Mux" None
echo disable 111
else
#Reconnect command
adb shell tinymix -D 0 "ASRC1-2 Mux" ADX1-1
adb shell tinymix -D 0 "ASRC1-3 Mux" I2S6
adb shell tinymix -D 0 "ASRC1-7 Mux" ARAD1
adb shell tinymix -D 0 "Lane2 enable" 1
adb shell tinymix -D 0 "Lane3 enable" 1
echo enable 1111
fi
