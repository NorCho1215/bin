ED.sh Em.RadioController
ED.sh Em.RadioService
ED.sh Em.GetAllPresetsAT
ED.sh Em.StorePresetAT
ED.sh Em.RemovePresetAT
ED.sh Em.PlayPauseButton
ED.sh Em.RadioDatabase
ED.sh Em.RadioActivity
ED.sh Em.MuteController
ED.sh Em.RadioBootReceiver
if [ -z $2 ];then
    /home/ncho/bin/adb logcat -c && /home/ncho/bin/adb logcat -v time |tee $1
else
    /home/ncho/bin/adb logcat -c && /home/ncho/bin/adb logcat -v time |grep $2|tee $1
fi
