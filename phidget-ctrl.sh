#!/bin/bash

if [ "$1" == "poweron" ]; then
	echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 power_on
elif [ "$1" == "poweroff" ]; then
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 power_off
elif [ "$1" == "reset" ]; then
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 reset
elif [ "$1" == "on" ]; then
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 onkey
elif [ "$1" == "recovery" ]; then
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 recovery_down
        sleep 1
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 reset
        sleep 1
        echo $passww | sudo -S python /home/ncho/bin/boardctl -t pm342 recovery_up
        #sudo python /home/ncho/bin/boardctl -t pm342 recovery
else
     echo "$1 command not found"
fi
