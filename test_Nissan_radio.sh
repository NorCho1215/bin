adb remount 
adb shell rm /system/priv-app/NDDNavigationBar/NDDNavigationBar.apk
adb shell stop
adb shell start
#sleep 30
adb remount 
adb push /home/ncho/Projects/upload/tempfile/NDDNavigationBar.apk /system/priv-app/NDDNavigationBar/.

