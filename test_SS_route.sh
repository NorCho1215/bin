echo "set selinux to debug mode"
adb shell setenforce permissive
adb shell tinymix -D 0 'AMX1-1 Mux' 'ADMAIF1'         
adb shell tinymix -D 0 |grep 'AMX1-1 Mux'
adb shell tinymix -D 0 'AMX1-2 Mux' 'ADMAIF2'
adb shell tinymix -D 0 |grep 'AMX1-2 Mux'
adb shell tinymix -D 0 'AMX1-3 Mux' 'ADMAIF3'
adb shell tinymix -D 0 |grep 'AMX1-3 Mux'
adb shell tinymix -D 0 'AMX1-4 Mux' 'ADMAIF4'
adb shell tinymix -D 0 |grep 'AMX1-4 Mux'
adb shell tinymix -D 0 'I2S3 Mux' 'AMX1'
adb shell tinymix -D 0 |grep 'I2S3 Mux'
adb shell tinymix -D 0 'ADMAIF1 Mux' 'ADX1-1'
adb shell tinymix -D 0 |grep 'ADMAIF1 Mux'
adb shell tinymix -D 0 'ADMAIF2 Mux' 'ADX1-2'
adb shell tinymix -D 0 |grep 'ADMAIF2 Mux'
adb shell tinymix -D 0 'ADMAIF3 Mux' 'ADX1-3'
adb shell tinymix -D 0 |grep 'ADMAIF3 Mux'
adb shell tinymix -D 0 'ADMAIF4 Mux' 'ADX1-4'
adb shell tinymix -D 0 |grep 'ADMAIF4 Mux'
adb shell tinymix -D 0 'ADX1 Mux' 'I2S3'
adb shell tinymix -D 0 |grep 'ADX1 Mux'
adb shell tinymix -D 0 'AMX2-1 Mux' 'ADMAIF5'
adb shell tinymix -D 0 |grep 'AMX2-1 Mux'
adb shell tinymix -D 0 'AMX2-2 Mux' 'ADMAIF6'
adb shell tinymix -D 0 |grep 'AMX2-2 Mux'
adb shell tinymix -D 0 'AMX2-3 Mux' 'ADMAIF7'
adb shell tinymix -D 0 |grep 'AMX2-3 Mux'
adb shell tinymix -D 0 'AMX2-4 Mux' 'ADMAIF8'
adb shell tinymix -D 0 |grep 'AMX2-4 Mux'
adb shell tinymix -D 0 'I2S4 Mux' 'AMX2'
adb shell tinymix -D 0 |grep 'I2S4 Mux'
adb shell tinymix -D 0 'ADMAIF5 Mux' 'ADX2-1'
adb shell tinymix -D 0 |grep 'ADMAIF5 Mux'
adb shell tinymix -D 0 'ADMAIF6 Mux' 'ADX2-2'
adb shell tinymix -D 0 |grep 'ADMAIF6 Mux'
adb shell tinymix -D 0 'ADMAIF7 Mux' 'ADX2-3'
adb shell tinymix -D 0 |grep 'ADMAIF7 Mux'
adb shell tinymix -D 0 'ADMAIF8 Mux' 'ADX2-4'
adb shell tinymix -D 0 |grep 'ADMAIF8 Mux'
adb shell tinymix -D 0 'ADX2 Mux' 'I2S4'
adb shell tinymix -D 0 |grep 'ADX2 Mux'
adb shell init_d3.sh
sleep 1
if [ "$1" == "playback" ]; then
   adb push /home/ncho/Projects/upload/MM_file/audio/tiny_test01.wav /sdcard/
   adb push /home/ncho/Projects/upload/MM_file/audio/tiny_test02.wav /sdcard/
   adb shell saf775x_util pset tdm1-out  pri-input
   adb shell saf775x_util vset pri-mute 0x07ff
   adb shell saf775x_util vset pri-vol1 0x07ff
   adb shell saf775x_util vset pri-vol2 0x0080
   adb shell tinyplay /sdcard/tiny_test01.wav
   adb shell tinyplay /sdcard/tiny_test02.wav
elif [ "$1" == "sinewave" ]; then
   adb shell saf775x_util pset sine-wave-out pri-input
elif [ "$1" == "record" ]; then
   adb shell saf775x_util cset adc1-conf 4
   adb shell saf775x_util cset adcen-conf 0
   adb shell saf775x_util pset an01-out sec-input
   adb shell saf775x_util pset sec-out-r tdm0-in1
   adb shell saf775x_util vset sec-mute 0x7ff
   adb shell saf775x_util vset sec-vol1 0x7ff
   adb shell saf775x_util vset sec-vol2 0x653
   adb shell tinycap /sdcard/cap.wav -D 0 -d 0
elif [ "$1" == "radio" ]; then
   echo "radio 111 "
   adb shell saf775x_util vset freq-tune-fm $2
   adb shell saf775x_util pset pri-radio-out pri-input
elif [ "$1" == "radio_mix" ]; then
   echo "radio_mix"
   adb shell tinymix -D 0 "MIXER1-1 Mux" "ADMAIF1"
   adb shell tinymix -D 0 "MIXER1-2 Mux" "ADX1-2"
   adb shell tinymix -D 0 "Adder1 RX1" "1"
   adb shell tinymix -D 0 "Adder1 RX2" "1"
   adb shell tinymix -D 0 "Mixer Enable" "1"
   adb shell tinymix -D 0 "AMX1-1 Mux" "MIXER1-1"
   adb shell saf775x_util vset freq-tune-fm $2
   adb shell saf775x_util pset pri-radio-out sec-input
   adb shell saf775x_util pset sec-out-r tdm0-in2
fi
