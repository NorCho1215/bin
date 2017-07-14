folder_name=$1
export TUNER_VERSION=$2

export PROJ=~/1T/$folder_name/$TUNER_VERSION
export DIR1="$PROJ/3rdparty/pelagicore/tuner/"
export DIR2="$PROJ/vendor/nvidia/tegra/3rdparty/nxp/pelagicore/"
export APPDIR="$PROJ/packages/apps/"

mkdir -p "$DIR1"
git clone git@git.pelagicore.net:nvidia-dirana3/d3ctl.git           "$DIR1/d3ctl"           -b "$TUNER_VERSION"
git clone git@git.pelagicore.net:nvidia-dirana3/pcoretuner.git      "$DIR1/pcoretuner"      -b "$TUNER_VERSION"
git clone git@git.pelagicore.net:nvidia-dirana3/pcoreutils.git      "$DIR1/pcoreutils"      -b "$TUNER_VERSION"
git clone git@git.pelagicore.net:nvidia-dirana3/tunerservice.git    "$DIR1/tunerservice"    -b "$TUNER_VERSION"
git clone git@git.pelagicore.net:nvidia-dirana3/librds.git          "$DIR1/librds"          -b "$TUNER_VERSION"

mkdir -p "$DIR2"
git clone git@git.pelagicore.net:nvidia-dirana3/dirana3tuner.git    "$DIR2/dirana3tuner"    -b "$TUNER_VERSION"

mkdir -p "$APPDIR"
git clone git@git.pelagicore.net:nvidia-dirana3/tunerapp.git        "$APPDIR/TunerApp"      -b "$TUNER_VERSION"
