
#
# build_kernel.sh <board> <target OS> [clean-build]
#

# $OUTDIR can be overided by environment variable
: ${OUTDIR:=}

function Usage()
{
	echo -e ""
	echo -e "Usage:"
	echo -e "\t$(basename $0) <board> <target OS> [clean-build]"
	echo -e "\t\t<board> can be 'vcm30t124', 'p1889', 'vcm31t210', 'vcm31t186' or 'mmxf2'"
	echo -e "\t\t<target OS> can be 'android', 'android-k44', 'linux', 'linux-vm1' or 'linux-vm2'"
	echo -e " build_kernel.sh drive_ref android-k44 clean-build"
        echo -e " build_kernel.sh drive_ref_int_k4_9 android-k49 clean-build"
}

if [ ! -f ./arch/arm/mach-tegra/Kconfig ]; then
	echo ""
	echo "This script needs to be executed under the root folder of linux kernel source codes"
	echo ""
	exit 1
fi

if [ "$1" == "" ] || [ "$2" == "" ]; then
	Usage
	exit 2
fi

BOARD=$1
TARGET_OS=$2
EXTRA_ARG=$3
SECURE_OS=
ARCH=
CROSS32CC=
DEFCONFIG_PATH=

if [ "$BOARD" == "vcm30t124" ] &&
   [ "$TARGET_OS" == "android" -o "$TARGET_OS" == "android-vm" -o "$TARGET_OS" == "android-vm1" -o "$TARGET_OS" == "android-vm2" ]; then
	DEFAULT_OUTDIR=../out/target/product/p1859/obj/KERNEL
	KERNEL_DEFCONFIG=tegra_vcm30t124_android_defconfig
	TOOLCHAIN_PREFIX=arm-eabi-
	DTB=( tegra124-android-p1859.dtb
	      tegra124-android-p1859-vm.dtb
	      tegra124-android-p1859-vm_1.dtb
	      tegra124-android-p1859-vm_2.dtb )
	SECURE_OS=tlk
	ARCH=arm
elif [ "$BOARD" == "vcm30t124" ] &&
     [ "$TARGET_OS" == "linux" -o "$TARGET_OS" == "linux-vm" ]; then
	DEFAULT_OUTDIR=../out/embedded-linux-vcm30t124-release/nvidia/kernel
	KERNEL_DEFCONFIG=tegra_vcm30t124_gnu_linux_defconfig
	TOOLCHAIN_PREFIX=$P4ROOT/sw/mobile/tools/linux/yocto/gcc-4.8.1-glibc-2.18-hard/usr/bin/armv7a-vfpv3-cortex_a15-linux-gnueabi/arm-cortex_a15-linux-gnueabi-
	DTB=( tegra124-p1859.dtb
	      tegra124-p1859-vm.dtb )
	ARCH=arm
elif [ "$BOARD" == "vcm30t124" ] && [ "$TARGET_OS" == "linux-vm1" ]; then
	DEFAULT_OUTDIR=../out/embedded-linux-vcm30t124-release/nvidia/kernel_vm1
	KERNEL_DEFCONFIG=tegra_vcm30t124_gnu_linux_vm_1_defconfig
	TOOLCHAIN_PREFIX=$P4ROOT/sw/mobile/tools/linux/yocto/gcc-4.8.1-glibc-2.18-hard/usr/bin/armv7a-vfpv3-cortex_a15-linux-gnueabi/arm-cortex_a15-linux-gnueabi-
	DTB=( tegra124-p1859-vm_1.dtb )
	ARCH=arm
elif [ "$BOARD" == "vcm30t124" ] && [ "$TARGET_OS" == "linux-vm2" ]; then
	DEFAULT_OUTDIR=../out/embedded-linux-vcm30t124-release/nvidia/kernel_vm2
	KERNEL_DEFCONFIG=tegra_vcm30t124_gnu_linux_vm_2_defconfig
	TOOLCHAIN_PREFIX=$P4ROOT/sw/mobile/tools/linux/yocto/gcc-4.8.1-glibc-2.18-hard/usr/bin/armv7a-vfpv3-cortex_a15-linux-gnueabi/arm-cortex_a15-linux-gnueabi-
	DTB=( tegra124-p1859-vm_2.dtb )
	ARCH=arm
elif [ "$BOARD" == "p1889" -o "$BOARD" == "bumblebee" ] &&
     [ "$TARGET_OS" == "android" -o "$TARGET_OS" == "android-vm" ]; then
	DEFAULT_OUTDIR=../out/target/product/p1889/obj/KERNEL
	KERNEL_DEFCONFIG=tegra12_p1889_android_defconfig
	TOOLCHAIN_PREFIX=arm-eabi-
	DTB=( tegra124-android-p1889.dtb
	      tegra124-android-p1889-vm.dtb
	      tegra124-android-p1889-hdmiprimary_nissanalt.dtb )
	SECURE_OS=tlk
	ARCH=arm
elif [ "$BOARD" == "vcm31t210" ] &&
     [ "$TARGET_OS" == "android" -o "$TARGET_OS" == "android-vm" -o "$TARGET_OS" == "android-vm2" ]; then
	DEFAULT_OUTDIR=../out/target/product/vcm31t210/obj/KERNEL
	KERNEL_DEFCONFIG=tegra_vcm31t210_android_defconfig
	TOOLCHAIN_PREFIX=`pwd`/../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
	DTB=( tegra210-vcm31-p2382-0000-a00-00.dtb
	      tegra210-vcm31-p2382-0000-a00-00-vm.dtb
	      tegra210-vcm31-p2382-0000-a00-00-vm2.dtb )
	ARCH=arm64
	CROSS32CC=`pwd`/../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-gcc
	KERNEL_CFLAGS=-mno-android
elif [ "$BOARD" == "vcm31t210" ] &&
     [ "$TARGET_OS" == "linux" -o "$TARGET_OS" == "linux-vm" -o "$TARGET_OS" == "linux-vm1" -o "$TARGET_OS" == "linux-vm2" ]; then
	DEFAULT_OUTDIR=../out/embedded-linux-t210ref-release/nvidia/kernel
	KERNEL_DEFCONFIG=tegra_t210ref_gnu_linux_defconfig
	TOOLCHAIN_PREFIX=`pwd`/../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
	DTB=( tegra210-vcm31-p2382-0000-a00-00.dtb
	      tegra210-vcm31-p2382-0000-a00-00-vm.dtb
	      tegra210-vcm31-p2382-0000-a00-00-vm1.dtb
	      tegra210-vcm31-p2382-0000-a00-00-vm2.dtb )
	ARCH=arm64
	CROSS32CC=`pwd`/../prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-gcc
	KERNEL_CFLAGS=-mno-android
elif [ "$BOARD" == "vcm31t186" -o "$BOARD" == "mmxf2" ] &&
     [ "$TARGET_OS" == "android" -o "$TARGET_OS" == "android-vm" -o "$TARGET_OS" == "android-vm1" ]; then
	DEFAULT_OUTDIR=../../out/target/product/vcm31t186/obj/KERNEL
	#DEFAULT_OUTDIR=`pwd`/../../out/target/product/vcm31t186/obj/KERNEL/kernel-3.18
	KERNEL_DEFCONFIG=tegra18_android_defconfig
	TOOLCHAIN_PREFIX=`pwd`/../../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
	DTB=( tegra186-vcm31-p2382-010-a01-00-base.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-vm.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-android-vm1.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-android-vm3-triple-guest.dtb
	      tegra186-vcm31-e2681-003-a01-00-base-android-vm1.dtb
	      tegra186-vcm31-e2681-003-a01-00-base-android-vm1-triple-guest.dtb )
	ARCH=arm64
	CROSS32CC=`pwd`/../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-gcc
	KERNEL_CFLAGS=-mno-android
	DEFCONFIG_PATH=`pwd`/../t18x/arch/arm64/configs
elif [ "$BOARD" == "drive_ref" -o "$BOARD" == "mmxf2" ] &&
     [ "$TARGET_OS" == "android-k44" -o "$TARGET_OS" == "android-k44-vm" -o "$TARGET_OS" == "android-k44-vm1" ]; then
	#DEFAULT_OUTDIR=../../out/target/product/vcm31t186_int_k/obj/KERNEL
	#DEFAULT_OUTDIR=../../out/target/product/vcm31t186/obj/KERNEL
	DEFAULT_OUTDIR=`pwd`/../../out/target/product/t186/obj/KERNEL/kernel-4.4
	KERNEL_DEFCONFIG=tegra18_android_defconfig
	TOOLCHAIN_PREFIX=`pwd`/../../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
	DTB=( tegra186-vcm31-p2382-010-a01-00-base.dtb )
	ARCH=arm64
	CROSS32CC=`pwd`/../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-gcc
	KERNEL_CFLAGS=-mno-android
	DEFCONFIG_PATH=`pwd`/../kernel-4.4/arch/arm64/configs
elif [ "$BOARD" == "t186" -o "$BOARD" == "mmxf2" ] &&
     [ "$TARGET_OS" == "android-k49" -o "$TARGET_OS" == "android-k49-vm" -o "$TARGET_OS" == "android-k49-vm1" ]; then
        #DEFAULT_OUTDIR=../../out/target/product/vcm31t186_int_k/obj/KERNEL
        #DEFAULT_OUTDIR=../../out/target/product/vcm31t186/obj/KERNEL
        DEFAULT_OUTDIR=`pwd`/../../out/target/product/vcm31t186/obj/KERNEL/kernel-4.9
        KERNEL_DEFCONFIG=tegra_android_defconfig
        TOOLCHAIN_PREFIX=`pwd`/../../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
        DTB=( tegra186-vcm31-p2382-010-a01-00-base.dtb )
        ARCH=arm64
        CROSS32CC=`pwd`/../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-gcc
        KERNEL_CFLAGS=-mno-android
        DEFCONFIG_PATH=`pwd`/../kernel-4.9/arch/arm64/configs
elif [ "$BOARD" == "drive_ref_int_k4_9" -o "$BOARD" == "mmxf2" ] &&
     [ "$TARGET_OS" == "android-k49" -o "$TARGET_OS" == "android-k49-vm" -o "$TARGET_OS" == "android-k49-vm1" ]; then
        #DEFAULT_OUTDIR=../../out/target/product/vcm31t186_int_k/obj/KERNEL
        #DEFAULT_OUTDIR=../../out/target/product/vcm31t186/obj/KERNEL
        DEFAULT_OUTDIR=`pwd`/../../out/target/product/t186_int_k4_9/obj/KERNEL/kernel-4.9
        KERNEL_DEFCONFIG=tegra_android_defconfig
        TOOLCHAIN_PREFIX=`pwd`/../../prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
        DTB=( tegra186-vcm31-p2382-010-a01-00-base.dtb )
        ARCH=arm64
        CROSS32CC=`pwd`/../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-gcc
        KERNEL_CFLAGS=-mno-android
        DEFCONFIG_PATH=`pwd`/../kernel-4.9/arch/arm64/configs
elif [ "$BOARD" == "vcm31t186" ] &&
     [ "$TARGET_OS" == "linux" -o "$TARGET_OS" == "linux-vm" -o "$TARGET_OS" == "linux-vm1" -o "$TARGET_OS" == "linux-vm2" ]; then
	DEFAULT_OUTDIR=../../out/embedded-linux-t186ref-release/nvidia/kernel
	KERNEL_DEFCONFIG=tegra_t186ref_gnu_linux_defconfig
	TOOLCHAIN_PREFIX=`pwd`/../../prebuilts/gcc/linux-x86/aarch64/gcc-4.9.2-glibc-2.21/usr/bin/aarch64-gnu-linux/aarch64-gnu-linux-
	DTB=( tegra186-vcm31-p2382-010-a01-00-base.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-vm.dtb
	      # tegra186-vcm31-p2382-010-a01-00-base-vm1-ebp-CES-demo.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-vm2.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-vm1-triple-guest.dtb
	      tegra186-vcm31-p2382-010-a01-00-base-vm2-ebp.dtb )
	ARCH=arm64
	CROSS32CC=`pwd`/../../prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-gcc
	KERNEL_CFLAGS=
	DEFCONFIG_PATH=`pwd`/../t18x/arch/arm64/configs
else
	echo ""
	echo "\"$BOARD\"/\"$TARGET_OS\" is not supported yet."
	echo ""
	exit 3
fi

if [ "$OUTDIR" == "" ]; then
	# The output folder is not set by user.  Set it as default value.
	OUTDIR=$DEFAULT_OUTDIR
fi

if [ "$EXTRA_ARG" == "clean-build" ]; then
	make clean O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC
	make mrproper O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC
fi

if [ ! -f $OUTDIR/.config ]; then
	mkdir -p $OUTDIR
	echo -e "make DEFCONFIG_PATH=$DEFCONFIG_PATH \033[91m$KERNEL_DEFCONFIG\033[0m O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC"
	make DEFCONFIG_PATH=$DEFCONFIG_PATH $KERNEL_DEFCONFIG O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC
else
	echo -e "\033[91mUsing existing $OUTDIR/.config\033[0m"
fi

# enable some needed kernel configs which are not described in defconfig
if [ "$SECURE_OS" == "tlk" ]; then
	./scripts/config --file $OUTDIR/.config --enable TRUSTED_LITTLE_KERNEL
fi

# build the kernel image
NUMCPUS=`cat /proc/cpuinfo | grep processor | wc -l`
make -j$NUMCPUS O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC LOCALVERSION="-tegra"

for dtb in ${DTB[@]}
do
	# build the DTB files
	if [ "$dtb" != "" ]; then
		make $dtb O=$OUTDIR SUBARCH=$ARCH CROSS_COMPILE=$TOOLCHAIN_PREFIX KCFLAGS=$KERNEL_CFLAGS CROSS32CC=$CROSS32CC

		if [ "$ANDROID_BUILD_TOP/kernel" == $PWD ] ||
		   [ "$ANDROID_BUILD_TOP/kernel/kernel-3.18" == $PWD ] ||
		   [ "$ANDROID_BUILD_TOP/kernel/kernel-4.4" == $PWD ]; then
			echo -e "\033[91mcp $OUTDIR/arch/$ARCH/boot/dts/$dtb $OUT/$dtb\033[0m"
			cp $OUTDIR/arch/$ARCH/boot/dts/$dtb $OUT/$dtb
		fi
	fi
done

