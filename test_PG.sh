adb shell insmod /system/lib/modules/snd-soc-saf775x.ko
adb shell ls /dev/ -l |grep saf
adb shell setenforce permissive
#adb shell 
adb logcat -c 
adb shell am start -n com.android.fmradio/com.android.fmradio.FmMainActivity & 
#sleep 5
#adb shell input keyevent 66
#sleep 3
#adb shell input keyevent 66
adb logcat -v time | tee Radio$1.log

