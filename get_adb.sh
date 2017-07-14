#!/bin/bash
echo $passww | sudo -S /home/ncho/bin/adb kill-server
echo $passww | sudo -S /home/ncho/bin/adb devices
