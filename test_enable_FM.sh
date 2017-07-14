#adb shell saf775x_util pset pri-radio-out pri-input
# init primary radio
#adb shell saf775x_util vset pri-radio-mode 0x000000 #FM standby
#adb shell saf775x_util vset pri-radio-mode 0x020000 #AM MW standby
#adb shell saf775x_util vset pri-radio-mode 0x040000 #WX standby
#adb shell saf775x_util vset pri-radio-mode 0x050000 #DAB standby


#adb shell saf775x_util vset pri-radio-tuner 0x00 # sensitivity: late AGC start BW: automatic bandwidth control (PACS)
#adb shell saf775x_util vset pri-radio 0xd8
# enable IMS:Improved multipath suppression CNS:Click noise suppression INCA:Improved noise cancellation algorithm
# NBSA Noise blanker(primary)
#adb shell saf775x_util vset pri-radio-signal 0x20 # FMSI:FM stereo improvement(on)

#adb shell saf775x_util vset pri-radio-mode 0x1026f2    #FM preset and channel 99.7 Mz

#adb shell saf775x_util vset pri-radio-mode 0x120288    #AM preset and channel 1116 kHz


adb shell saf775x_util vset src0-set 0x800000     # enable Dirana primary channel SRC
adb shell saf775x_util vset freq-tune-fm 9970        # tune primary radio to 94.30 MHz
adb shell saf775x_util pset pri-radio-out pri-input
adb shell saf775x_util vset pri-mute 0x07ff
adb shell saf775x_util vset pri-vol1 0x08ff
adb shell saf775x_util vset pri-vol2 0x0080
