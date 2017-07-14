#!/bin/bash
base_folder=/home/ncho/1T
if [ "$#" -lt 3 ]; then
    echo "command: /home/ncho/bin/build_NXP.sh <folder> <build_name a/l/q> <re-init>"
    echo "e.g. /home/ncho/bin/build_NXP.sh NXP_BUILD a Y"
else
   folder_name=$1
   test ! -d $base_folder/$folder_name && mkdir -p $base_folder/$folder_name
   cd $base_folder/$folder_name
   export TOP=$(pwd)
   build_name=$2
   re_init=$3
   if [ "$re_init" == "Y" ]; then
        if [ "$build_name" == "a" ]; then
             rm $base_folder/$folder_name/android -rf 
             mkdir -p $base_folder/$folder_name/android
             cd $base_folder/$folder_name/android
             repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=main -m android-nxp.xml -g userspace,android-nxp
             repo sync -cj4
        elif [ "$build_name" == "l" ]; then
             rm $base_folder/$folder_name/linux -rf
             mkdir -p $base_folder/$folder_name/linux
             cd $base_folder/$folder_name/linux
 	     repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=main  -m nxp.xml
             repo sync -cj4
        fi
   fi
   if [ "$build_name" == "a" ]; then
        cd $base_folder/$folder_name/android
	export TOP=$(pwd) && export SECURE_OS_BUILD=n &&. build/envsetup.sh && setpaths && choosecombo 1 vcm31t186ref 3
        m saf775x_util
        m libdirana3tuner
   elif [ "$build_name" == "l" ]; then
       cd $base_folder/$folder_name/linux
       source tmake/scripts/envsetup.sh
       choose embedded-linux t186ref none release internal aarch64
       rm out -rf 
       make -f 3rdparty/nxp/tmake/Makefile.3rdparty.nxp NV_BUILD_SYSTEM_TYPE="embedded-linux"
   fi
fi
