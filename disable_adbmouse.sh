/home/ncho/bin/adb disconnect `adb devices |awk '{print $1}' |grep 10.19 | cut -c 1-13`
echo $passww |sudo -S kill -9 `ps -aux |grep adbmouse |awk '{print $2}'`
