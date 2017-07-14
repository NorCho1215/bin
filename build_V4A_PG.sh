#!/bin/bash
code_path="/home/ncho/1T"

cd /home/ncho/1T/V4A_24.05/android/
export TOP=$(pwd) && export SECURE_OS_BUILD=n && . build/envsetup.sh && setpaths && choosecombo 1 vcm31t210ref 3
cd $TOP/3rdparty/pelagicore/tuner/pcoreutils
mm
cd $TOP/3rdparty/pelagicore/tuner/librds
mm
cd $TOP/3rdparty/pelagicore/tuner/pcoretuner
mm
cd $TOP/3rdparty/pelagicore/tuner/tunerservice
mm
cd $TOP/3rdparty/pelagicore/tuner/TunerApp
mm
cd $TOP/vendor/nvidia/tegra/3rdparty/nxp/pelagicore/dirana3tuner/
mm
