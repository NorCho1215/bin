#!/bin/bash

code_path="/home/ncho/1T"

cd $code_path

cd $1 #for code folder

if [ "$2" == "Y" ]; then
test -d .repo && echo "rm * -rf" # rm * -rf
repo sync -j4
fi

prebuilts/misc/linux-x86/ccache/ccache -M 50G

export TOP=$(pwd) && . build/envsetup.sh && setpaths && choosecombo 1 p1859ref 3 && mp dev >> build_$1.log 2>&1

