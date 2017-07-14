#!/bin/bash
folder=$1
branch=$2
build=$3
sync=$4
if [ "$#" -lt 3 ]; then
  echo "command : /home/ncho/bin/repo_init.sh <folder> <branch> <build> <sync>"
  echo "e.g. /home/ncho/bin/repo_init.sh V4A_Alpha2 embedded/25.05.03 a Y/N"
  exit 1
else
 if [ "$build" == "a" ]; then
    test ! -d /home/ncho/1T/$folder/android && mkdir -p /home/ncho/1T/$folder/android
    cd /home/ncho/1T/$folder/android
    repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=$branch --manifest-name=android-next.xml
 elif [ "$build" == "f" ]; then
    test ! -d /home/ncho/1T/$folder/foundation && mkdir -p /home/ncho/1T/$folder/foundation
    cd /home/ncho/1T/$folder/foundation
    repo init -u ssh://git-master:12001/tegra/manifest.git -b $branch -m embedded-foundation.xml
 elif [ "$build" == "q" ]; then
    test ! -d /home/ncho/1T/$folder/qnx && mkdir -p /home/ncho/1T/$folder/qnx
    cd /home/ncho/1T/$folder/qnx
    repo init -u ssh://git-master:12001/tegra/manifest.git -b $branch -m embedded-qnx.xml
 elif [ "$build" == "l" ]; then
    test ! -d /home/ncho/1T/$folder/linux && mkdir -p /home/ncho/1T/$folder/linux
    cd /home/ncho/1T/$folder/linux
    repo init -u ssh://git-master:12001/tegra/manifest.git -b $branch -m embedded-linux.xml  
 fi
 if [ "$sync" == "Y" ]; then
    test -d  .repo && rm * -rf
    repo sync -cj4
 fi
fi
