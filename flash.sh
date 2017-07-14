#!/bin/bash

# enable globbing in case it has already been turned off
set +f

pkg_filter=android_*_os_image-*.tgz
pkg=$(echo $pkg_filter)
pkg_dir="_${pkg/%.tgz}"
host_bin="out/host/linux-x86/bin"

if [[ "$pkg" != "$pkg_filter" && -f $pkg && ! -d "$pkg_dir" ]]; then
    echo "Extracting $pkg...."
    mkdir $pkg_dir
    (cd $pkg_dir && tar xfz ../$pkg)
    find $pkg_dir -maxdepth 2 -type f -exec cp -u {} out/target/product/vcm31t186 \;

    # copy host bins
    find $pkg_dir -path \*$host_bin\* -type f -exec cp -u {} $host_bin \;

    # check if system_gen.sh was used
    x=$(basename $pkg_dir/android_*_os_image*)
    [ -d "$x" ] && {
        echo "************************************************************"
        echo
        echo "WARNING:"
        echo "    Looks like \"system_img.gen\" was used."
        echo "    \"./flash.sh\" is the only script needed for flashing."
        echo
        echo "************************************************************"
    }
fi

#!/bin/bash
# NVIDIA Tegra "VCM31T186" development system
#
# Copyright (c) 2015 NVIDIA Corporation.  All rights reserved.

if [ "$TEST_AUTOMATION" == 1 ]; then
ANDROID_TARGET_DEVICE=$TARGET_DEVICE \
ANDROID_BUILD_FLAVOR=release \
NV_BUILD_CONFIGURATION_IS_DEBUG=0 \
NV_TARGET_BOARD=t186ref \
TARGET_BOARD=t186ref \
EMBEDDED_TARGET_PLATFORM=t186ref-foundation \
TEGRA_TOP=$PWD/foundation \
NV_OUTDIR=$PWD/foundation/out/embedded-foundation-t186ref-release \
foundation/embedded/tools/scripts/t186_bootburn/bootburn.sh -a -b p2382-t186 -M \
-k $PWD/foundation/embedded/tools/boards/t186ref/quickboot_qspi_nor_android.cfg.sanity $@
else
ANDROID_TARGET_DEVICE=$TARGET_DEVICE \
ANDROID_BUILD_FLAVOR=release \
NV_BUILD_CONFIGURATION_IS_DEBUG=0 \
NV_TARGET_BOARD=t186ref \
TARGET_BOARD=t186ref \
EMBEDDED_TARGET_PLATFORM=t186ref-foundation \
TEGRA_TOP=$PWD/../foundation \
NV_OUTDIR=$PWD/../foundation/out/embedded-foundation-t186ref-release \
../foundation/embedded/tools/scripts/t186_bootburn/bootburn.sh -a -b p2382-t186 -M $@
fi
