#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/keyE.sh <home/tab/enter>"
else

    if [ "$1" == "home" ]; then
       /home/ncho/bin/adb shell input keyevent 3
    elif [ "$1" == "tab" ]; then
       /home/ncho/bin/adb shell input keyevent 61
    elif [ "$1" == "enter" ]; then
       /home/ncho/bin/adb shell input keyevent 23
    elif [ "$1" == "back" ]; then
       /home/ncho/bin/adb shell input keyevent 4
    elif [ "$1" == "unlock" ]; then
       /home/ncho/bin/adb shell input keyevent 66
    elif [ "$1" == "test" ]; then
       /home/ncho/bin/adb shell input text $1
    elif [ "$1" == "stay" ]; then
       /home/ncho/bin/adb svc power stayon true
    fi
fi

