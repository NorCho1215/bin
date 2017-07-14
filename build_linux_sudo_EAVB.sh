#!/bin/bash
if [ "$1" == "Y" ]; then
 cd /home/ncho/1T/linux
 echo $passww|sudo -S rm * -rf 
 repo init -u ssh://git-master:29418/tegra/manifest.git -b embedded/23.10.01 -m k310-embedded.xml
 repo sync -cj8
fi
echo $passww|sudo -S /home/ncho/bin/build_linux_EAVB.sh linux
