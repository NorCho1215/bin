#!/bin/bash

code_path="/home/ncho/1T"
export P4ROOT="/home/ncho/Projects/upload/p4"

#PATH+=:$P4ROOT/sw/misc/linux/
#chown root $P4ROOT/sw/misc/linux/unix-build
#chmod u+s $P4ROOT/sw/misc/linux/unix-build

if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/build_foundation.sh <folder>"
else
    cd $code_path/$1 #for code folder
    echo "Daily build linux process start" > build_foundation.log 2>&1
    echo `date` >> build_foundation.log 2>&1
    echo "======rm out -rf & P4ROOT=$P4ROOT path=$code_path/$1======" > build_foundation.log 2>&1
    test -d $code_path/$1/.repo && rm out -rf
    echo "======source tmake/scripts/envsetup.sh=======" >> build_foundation.log 2>&1 
    source tmake/scripts/envsetup.sh >> build_foundation.log 2>&1
    echo "====== choose embedded-foundation vcm30t124 none release ======" >> build_foundation.log 2>&1
    choose embedded-foundation vcm30t124 none release >> build_foundation.log 2>&1
    echo "====== source foundation/mk_blob.sh ======" >> build_foundation.log 2>&1
    source foundation/mk_blob.sh >> build_foundation.log 2>&1
    echo "====== tmp ======" >> build_foundation.log 2>&1
    tmp >> build_foundation.log 2>&1
    echo "====== tmp systemimage ======" >> build_foundation.log 2>&1
    tmp systemimage >> build_foundation.log 2>&1
    echo "====== bind_partitions android-linux-pl ======" >> build_foundation.log 2>&1
    bind_partitions android-linux-pl >> build_foundation.log 2>&1
    echo "====== End ======" >> build_foundation.log 2>&1
    echo "Daily build linux process end" >> build_foundation.log 2>&1
    echo `date` >> build_foundation.log 2>&1
fi
