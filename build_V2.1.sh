#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"

sudo update-java-alternatives -s java-6-sun
export TOP=$(pwd)
source build/envsetup.sh
choosecombo 1 vcm30t30 3
mp dev
