#!/bin/bash

code_path="/home/ncho/1T"

if [ "$#" -lt 3 ]; then
    echo "command: /home/ncho/daily_build.sh <folder> <project> <re-sync>"
else
    cd $code_path/$1
    echo `pwd` > build_$1_$2.log 2>&1
    echo "Daily build process start" >> build_$1_$2.log 2>&1
    echo `date` >> build_$1_$2.log 2>&1
    if [ "$3" == "N" ]; then
       echo "NNNNN"
        test -d .repo && echo "rm out" >> build_$1_$2.log 2>&1
        test -d .repo && rm out -rf
    elif [ "$3" == "Y" ]; then #clean build and sync code.
       echo "YYYY"
        test -d .repo && echo "rm * -rf" >> build_$1_$2.log 2>&1
        echo "Daily build rm all finish" >> build_$1_$2.log 2>&1
        echo `date` >> build_$1_$2.log 2>&1
        test -d .repo && rm * -rf
        test -d .repo && /usr/local/bin/repo sync -cj4 >> build_$1_$2.log 2>&1
        echo "Daily build clean or sync end" >> build_$1_$2.log 2>&1
        echo `date` >> build_$1_$2.log 2>&1
        #cscope -Rbkq
        #ctags -R *
    fi
    if [ "$3" != "Y" ] && [ "$3" != "N" ]; then 
        sleep $4
    fi
    test -d .repo && /home/ncho/bin/build_p.sh $1 $2
    echo "Daily build process End" >> build_$1_$2.log 2>&1
    echo `date` >> build_$1_$2.log 2>&1
fi
