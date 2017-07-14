#!/bin/bash
case=$2
run=$1
reboot_timing=7
folder="/home/ncho/Projects/upload/FFBE"
date=`date +%Y%m%d`
time=`date +%H%M`
log_file="$folder/$date/$time/debug.log"
echo "$folder"
echo "$date"
echo "$time"

function cap_img(){
    /home/ncho/bin/adb -s CB512168CU shell screencap -p /sdcard/screen_${1}.png
    /home/ncho/bin/adb -s CB512168CU pull /sdcard/screen_${1}.png
    /home/ncho/bin/adb -s CB512168CU shell rm /sdcard/screen_${1}.png
}

function sleep_fun(){
    if [ "$1" == "overnight" ]; then
        sleep $2
    else
	sleep $3
    fi
}

function sleep_fun_debug(){
    if [ "$1" == "overnight" ]; then
        sleep $3
	#cap_img "${2}" ## for debug overnight
    else
        echo "${2}" |tee -a $log_file
        sleep $4
        if [ "$1" == "debug" ]; then
            cap_img "${2}"
        fi
        sleep $5
    fi
}

function reset_device(){
    echo reset_device $1 $2 |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell input keyevent 3 ## home key
    sleep_fun $1 5 3 # overnight=$2 another=$3
    #echo "home" |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell am force-stop com.square_enix.android_googleplay.FFBEWW
    echo "kill FFBE" |tee -a $log_file
    sleep_fun $1 10 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 100 792 ## app icon
    echo "app icon" |tee -a $log_file
    sleep 50
    echo "reset_device_overnight !!`date +%Y%m%d:%H%M:%S`" |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell input tap 100 792 ## touch for input.
    #echo "touch first input" |tee -a $log_file
    sleep_fun $1 80 70
    /home/ncho/bin/adb -s CB512168CU shell input tap 100 770 ## to cancel the ask.
    #echo "to cancel the ask" |tee -a $log_file
    sleep 10
}

function setup_trust(){
    /home/ncho/bin/adb -s CB512168CU shell input tap 365 953 #world
    sleep_fun $1 15 10 # overnight=$2 another=$3
    #echo "world" |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell input tap 690 630 # first 
    #echo "select 1" |tee -a $log_file
    sleep_fun $1 10 10
    /home/ncho/bin/adb -s CB512168CU shell input tap 489 533 # select 2
    #echo "select 2" |tee -a $log_file
    sleep_fun $1 7 7
    /home/ncho/bin/adb -s CB512168CU shell input swipe 345 953 754 953 #  move to action 1
    #echo "move to action 1" |tee -a $log_file
    sleep_fun $1 7 7
    /home/ncho/bin/adb -s CB512168CU shell input tap 513 897 # action 1
    #echo "action 1" |tee -a $log_file
    sleep_fun $1 10 7
    echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
}
function run_ring() {
    /home/ncho/bin/adb -s CB512168CU shell input swipe 200 850 100 850 ## open item
    sleep 3
    /home/ncho/bin/adb -s CB512168CU shell input tap 200 850 ## item1
    sleep 2
    /home/ncho/bin/adb -s CB512168CU shell input tap 200 850 ## 1rd man
    sleep 3
    /home/ncho/bin/adb -s CB512168CU shell input swipe 200 950 300 950 ## 2rd open action
    sleep 2
    /home/ncho/bin/adb -s CB512168CU shell input swipe 200 950 200 650 ## move to up
    sleep 3
    /home/ncho/bin/adb -s CB512168CU shell input tap 500 850 ## 2rd action.
    sleep 2
}
#sleep_fun_debug $1 <overnight/4pm/debug> "${2}<$i> _step_2" overnight_time delay_1 delay_2
function run_trust() {
    echo "run_trust $1 $2 $run `date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell input tap 423 645
    sleep_fun_debug $1 "${2}_1_game_2" 10 2 3
    /home/ncho/bin/adb -s CB512168CU shell input tap 372 1124
    sleep_fun_debug $1 "${2}_2_step_2" 10 2 3
    /home/ncho/bin/adb -s CB512168CU shell input tap 456 532
    sleep_fun_debug $1 "${2}_3_slect_team" 10 2 3
    /home/ncho/bin/adb -s CB512168CU shell input tap 397 1084
    sleep_fun_debug $1 "${2}_4_game_start" 45 15 25
    run_ring
    /home/ncho/bin/adb -s CB512168CU shell input tap 104 1238
    sleep_fun_debug $1 "${2}_5_auto" 90 20 70
    /home/ncho/bin/adb -s CB512168CU shell input tap 350 1100
    if [ "$1" == "overnight" ]; then
	if [ "$i" == "0" ] || [ "$i" -gt "$(($run-5))" ]; then
              echo "Capture screen_${i}.png" | tee -a $log_file
              sleep 5
	      cap_img ${i}
              sleep 5
        else
	      sleep 5
	      cap_img ${i}
              sleep 5
        fi
    else
	echo "next1" |tee -a $log_file
	sleep 5
	if [ "$1" == "debug" ]; then
	    echo "Capture screen_${i}.png" | tee -a $log_file
	    cap_img "${2}_6_next1"
	fi
	sleep 5
    fi
    /home/ncho/bin/adb -s CB512168CU shell input tap 350 1100
    sleep_fun_debug $1 "${2}_7_next2" 10 5 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 350 1100
    /home/ncho/bin/adb -s CB512168CU shell input tap 350 1100
    sleep_fun_debug $1 "${2}_8_next3" 15 5 10
}

function run_items() {
    echo "4pm_items" |tee -a $log_file
    /home/ncho/bin/adb -s CB512168CU shell input tap 640 900 # make item
    echo "make item" |tee -a $log_file
    sleep 10
    /home/ncho/bin/adb -s CB512168CU shell input tap 640 380 # option 3
    echo "slect Props" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # first item
    echo "first item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 860 # get first item
    echo "get first item" |tee -a $log_file
    sleep 8
    reset_device "4pm_items"
    /home/ncho/bin/adb -s CB512168CU shell input tap 640 900 # make item
    echo "make item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 640 380 # option 3
    echo "option 3" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # first item
    echo "first item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # make 1rd itmes
    echo "make 1rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 940 # make
    echo "make" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 720 # yes for make
    echo "yes for make" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd  item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 860 # get item
     echo "get item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd  item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # make 1rd itmes
    echo "make 1rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 940 # make
    echo "make" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 720 # yes for make
    echo "yes for make" |tee -a $log_file
    sleep 8
################################################################ option 2
    /home/ncho/bin/adb -s CB512168CU shell input tap 350 400 # option 2
    echo "option 2" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 860 # get item
    echo "get item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 400 # white magic
    echo "White magic" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 940 # make
    echo "make" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 720 # yes for make
    echo "yes for make" |tee -a $log_file
    sleep 8
################################################################# option 1
    /home/ncho/bin/adb -s CB512168CU shell input tap 150 400 #option 1
    echo "option 1" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd items" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 860 # get item
    echo "get item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 700 # 2rd item
    echo "2rd item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 400 # DFE item
    echo "DEF item" |tee -a $log_file
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # first item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 940 # make
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 720 # yes for make
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 850 # 3rd item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 860 # get item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 850 # 2rd item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 400 # DFE item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 300 510 # first item
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 940 # make
    sleep 8
    /home/ncho/bin/adb -s CB512168CU shell input tap 470 720 # yes for ma
    sleep 8
}

function run_friend() {
    /home/ncho/bin/adb -s CB512168CU shell input tap 660 1210 # friend
    echo "friend" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 570 610 #gift
    echo "gift" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 610 270 # sent
    echo "sent" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 410 300 # all sent
    echo "all sent" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 610 270 # receiver
    echo "receiver" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 410 300 # all receiver
    echo "all receiver" |tee -a $log_file
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 40 300 # back
    echo "back" |tee -a $log_file
    sleep 10
    /home/ncho/bin/adb -s CB512168CU shell input keyevent 3
}

function setup_map(){
    /home/ncho/bin/adb -s CB512168CU shell input tap 365 953 #world
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 342 431 # slect1
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 489 533 # select 2
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input swipe 500 953 200 500
    sleep 5
    /home/ncho/bin/adb -s CB512168CU shell input tap 450 1000 #
    sleep 5
}

if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/ffbe_rank.sh <run> <t_120/overnight/overnight_debug/4pm<items/trust/friend>>"
else
    if [ "$case" == "4pm" ]; then
	/bin/mkdir -p $folder/$date/$time
        cd $folder/$date/$time
	echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
	reset_device "first_initial"
        reset_device "4pm_friend"
        run_friend
	echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
	## ====================================================================
        reset_device "4pm_items"
        run_items
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
	## ====================================================================
	reset_device "4pm_trust"
	setup_trust "4pm"
	for ((i=0; i<${run}; i=i+1))
	do
	    echo "4pm_trust $i" |tee -a $log_file
	    run_trust 4pm $i
	done
	echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
        ##=================================
	/home/ncho/bin/adb -s CB512168CU shell input keyevent 3 # go to home for charge.
        sleep 3
        /home/ncho/bin/adb -s CB512168CU shell am force-stop com.square_enix.android_googleplay.FFBEWW
    elif [ "$case" == "4pm_items" ]; then
        echo $a_passwd| sudo -S /bin/mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
        reset_device "4pm_items"
        run_items
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
    elif [ "$case" == "4pm_trust" ]; then
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
	reset_device "4pm_trust"
        setup_trust "4pm"
        for ((i=0; i<${run}; i=i+1))
        do
            echo "4pm_trust %i" |tee -a $log_file
            run_trust 4pm $i
        done
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
    elif [ "$case" == "4pm_friend" ]; then
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
	reset_device "4pm_friend"
        run_friend $1
	echo "`date +%Y%m%d:%H%M:%S` $1" |tee -a $log_file
    elif [ "$case" == "overnight_debug" ]; then
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        /home/ncho/bin/adb -s CB512168CU shell input keyevent 3
        sleep 2
	cap_img "start"
        for ((i=0; i<=${run}; i=i+1))
        do
            j=$(( $i % $reboot_timing ))
            echo $j
            if [ $j == "0" ]; then
                     reset_device debug $i
                     setup_trust debug $i
            fi
            echo "run $i  `date +%Y%m%d:%H%M:%S`" |tee -a $log_file
	    run_trust debug $i
        done
        /home/ncho/bin/adb -s CB512168CU shell input keyevent 3 # go to home for charge.
        sleep 3
        /home/ncho/bin/adb -s CB512168CU shell am force-stop com.square_enix.android_googleplay.FFBEWW
        sleep 3
	cap_img "end"
    elif [ "$case" == "overnight" ]; then
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
	/home/ncho/bin/adb -s CB512168CU shell input keyevent 3
	sleep 2
	cap_img "start"
        for ((i=0; i<=${run}; i=i+1))
        do
            j=$(( $i % $reboot_timing ))
            echo $j
            if [ $j == "0" ]; then
                     reset_device overnight $i
		     setup_trust overnight $i
            fi
            echo "run $i  `date +%Y%m%d:%H%M:%S`" |tee -a $log_file
	    run_trust overnight $i
        done
	/home/ncho/bin/adb -s CB512168CU shell input keyevent 3 # go to home for charge.
	sleep 3
	/home/ncho/bin/adb -s CB512168CU shell am force-stop com.square_enix.android_googleplay.FFBEWW
	sleep 3
	cap_img "end"
    elif [ "$case" == "t_120" ]; then
        echo "t_120"
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        reset_device t_120
	setup_trust t_120
        for ((i=0; i<=${run}; i=i+1))
        do
            echo "run $i `date +%Y%m%d:%H%M:%S`" |tee -a $log_file
	    run_trust t_120 $i
        done
     elif [ "$case" == "reset_device" ]; then
        echo $a_passwd| sudo -S mkdir -p $folder/$date/$time
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date
        echo $a_passwd| sudo -S chown nvidia.nvidia $folder/$date/$time
        cd $folder/$date/$time
        reset_device "test" |tee -a $log_file
	setup_trust "test"
    else
        echo "$case don't support"
    fi
       echo "Task finish"
fi
exit 0
