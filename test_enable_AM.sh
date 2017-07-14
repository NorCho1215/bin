adb shell saf775x_util pset pri-radio-out pri-input
# init primary radio
adb shell saf775x_util vset pri-radio-mode 0x000000 #FM standby
adb shell saf775x_util vset pri-radio-mode 0x020000 #AM MW standby
#adb shell saf775x_util vset pri-radio-mode 0x040000 #WX standby
#adb shell saf775x_util vset pri-radio-mode 0x050000 #DAB standby

adb shell saf775x_util vset pri-radio-tuner-opt 0x00
#adb shell saf775x_util vset pri-radio-tuner 0x00 # sensitivity: late AGC start BW: automatic bandwidth control (PACS)
#adb shell saf775x_util vset pri-radio 0xd8
# enable IMS:Improved multipath suppression CNS:Click noise suppression INCA:Improved noise cancellation algorithm
# NBSA Noise blanker(primary)
#adb shell saf775x_util vset pri-radio-signal 0x20 # FMSI:FM stereo improvement(on)

adb shell saf775x_util vset pri-radio-mode 0x12046e    #AM preset and channel 1134 kHz


i=757

while [ "$i" != "1711" ]
do
   HEX_NUM=`echo "obase=16; ${i}" | bc`
   echo 0x12$HEX_NUM
   adb shell saf775x_util vset pri-radio-mode 0x120$HEX_NUM
   sleep 1
   adb shell saf775x_util vset pri-radio-mode 0x020000 #AM MW standby
   i=$(($i+1))
done
