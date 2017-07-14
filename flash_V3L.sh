source tmake/scripts/envsetup.sh
choose embedded-linux vcm30t124 none release external x11
export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
flash -e -r mmcblk0 -F "/dev/block/mmcblk0 ext4 $TEGRA_TOP/out/embedded-linux-vcm30t124-release/target_rootfs/"

