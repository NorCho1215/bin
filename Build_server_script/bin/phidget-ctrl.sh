#!/bin/bash

if [ "$1" == "poweron" ]; then
	sudo python /home/autotw/bin/boardctl -t pm342 power_on
elif [ "$1" == "poweroff" ]; then
        sudo python /home/autotw/bin/boardctl -t pm342 power_off
elif [ "$1" == "reset" ]; then
        sudo python /home/autotw/bin/boardctl -t pm342 reset
elif [ "$1" == "recovery" ]; then
        sudo python /home/autotw/bin/boardctl -t pm342 recovery_down
        sudo python /home/autotw/bin/boardctl -t pm342 reset
        sudo python /home/autotw/bin/boardctl -t pm342 recovery_up
        #sudo python /home/autotw/bin/boardctl -t pm342 recovery
else
     echo "$1 command not found"
fi
