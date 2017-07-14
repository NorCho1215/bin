#!/bin/bash

code_folder=/home/ncho/1T/$1
if [ "$#" -lt 2 ]; then
    echo "command: /home/ncho/bin/setup_v4a.sh <folder> <sync - Y/N> <branch> "
else
    
    test ! -d $code_folder && mkdir -p $code_folder
    ## android code
    test ! -d $code_folder/android && mkdir -p $code_folder/android
    cd $code_folder/android
    if [ "$3" == "" ]; then
        echo "get main branch"
        if [ "$2" == "Y" ]; then
            test -d /home/ncho/1T/V4A_main/android/.repo && rm $code_folder/android/.repo -rf &&cp /home/ncho/1T/V4A_main/android/.repo -rf $code_folder/android
        fi
        /usr/local/bin/repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=main --manifest-name=android.xml
    else
        echo "get special branch"
        /usr/local/bin/repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=$2 --manifest-name=android.xml
    fi
    if [ "$2" == "Y" ]; then
        test -d .repo && /usr/local/bin/repo sync -cj6
    fi
    #### foundation code
    test ! -d $code_folder/foundation && mkdir -p $code_folder/foundation
    cd $code_folder/foundation
    if [ "$3" == "" ]; then
        echo "get main branch"
        /usr/local/bin/repo init -u ssh://git-master:12001/tegra/manifest.git -b main -m embedded-foundation.xml
    else
        echo "get special branch"
        /usr/local/bin/repo init -u ssh://git-master:12001/tegra/manifest.git -b $2 -m embedded-foundation.xml
    fi
    if [ "$2" == "Y" ]; then
        test -d .repo && /usr/local/bin/repo sync -cj6
    fi
fi
