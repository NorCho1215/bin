adb shell tinymix -D 0 'AMX1-1 Mux' 'ADMAIF1' 
adb shell tinymix -D 0 'ADX1 Mux' 'AMX1'
adb shell tinymix -D 0 'ADMAIF1 Mux' 'ADX1-1'
adb shell tinyplay /sdcard/tiny_test02.wav &
adb shell tinycap /data/cap.wav -D 0 -d 0 -c 2 -r 48000 -b 16
#adb shell tinycap /data/cap.wav -D 1 -d 0 -c 2 -r 48000 -b 16

