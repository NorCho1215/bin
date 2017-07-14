/home/ncho/bin/adb remount
sleep 1
/home/ncho/bin/adb root
sleep 1
/home/ncho/bin/adb push /home/ncho/bin/adbmoused /data/
/home/ncho/bin/adb forward tcp:3456 tcp:3456
/home/ncho/bin/adb shell /data/adbmoused &
echo $passww |sudo -S /home/ncho/bin/adbmouse /dev/input/event2
