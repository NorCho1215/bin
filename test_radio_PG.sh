adb remount
adb shell mkdir /etc/tuner/
adb push  $TOP/3rdparty/pelagicore/tuner/pcoreutils/tunerpref/dirana3tuner.conf /etc/tuner/
adb push  $TOP/3rdparty/pelagicore/tuner/pcoreutils/tunerpref/lowleveltuner.conf /etc/tuner/
adb push  $TOP/3rdparty/pelagicore/tuner/pcoreutils/tunerpref/pcoretuner.conf /etc/tuner/
