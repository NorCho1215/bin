adb root
sleep 3
adb remount
sleep 2
adb shell setprop enable-prof 1                                  
adb shell setprop enable-seek 1                                  
                                 
adb shell setprop enable-showJitter 1                                  
adb shell setprop enable-noAud 1                                  
#adb shell setprop enable-noAvs 1                                  
#adb shell setprop enable-noRend 1  
