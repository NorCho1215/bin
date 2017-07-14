
if [ "$TEGRA_TOP" != $PWD ]; then
	echo ""
	echo -e "\033[91mThis script needs to be executed under the root folder of Vibrante Foundation source codes.\033[0m"
	echo ""
fi

function Usage()
{
	echo -e ""
	echo -e "\033[91mUsage:\033[0m"
	echo -e "\tsource /usr/local/bin/flash_v4x.sh <os> <board>" 
	echo -e "\t\t<os> can be 'linux', 'android', 'qnx' or 'hypervisor'"
	echo -e "\t\t<board> can be 't210ref' or 't186ref'"
	echo -e ""
}

export TOP_V4F=`pwd`

ARG_OS=$1
ARG_BOARD=$2

# discard the 1st and 2nd arguments
shift
shift

if [ "$ARG_OS" == "linux" ]; then
	if [ "$ARG_BOARD" == "t210ref" ]; then
		eenv ./embedded/tools/scripts/t210_bootburn/bootburn.sh -b p2382a00 $@
	elif [ "$ARG_BOARD" == "t186ref" ]; then
		eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 -M -k `pwd`/embedded/tools/boards/t186ref/quickboot_qspi_linux_fs.cfg $@
	else
		Usage
	fi
elif [ "$ARG_OS" == "android" ]; then
	if [ "$ARG_BOARD" == "t210ref" ]; then
		ANDROID_BUILD_FLAVOR=release eenv ./embedded/tools/scripts/t210_bootburn/bootburn.sh -a -b p2382a00 $@
	elif [ "$ARG_BOARD" == "t186ref" ]; then
		ANDROID_BUILD_FLAVOR=release eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 -M -a $@
	else
		Usage
	fi
elif [ "$ARG_OS" == "qnx" ]; then
	if [ "$ARG_BOARD" == "t210ref" ]; then
		eenv ./embedded/tools/scripts/t210_bootburn/bootburn.sh -q -b p2382a00 $@
	elif [ "$ARG_BOARD" == "t186ref" ]; then
		eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 -M -q $@
	else
		Usage
	fi
elif [ "$ARG_OS" == "hypervisor" ]; then
	if [ "$ARG_BOARD" == "t210ref" ]; then
		eenv ./embedded/tools/scripts/t210_bootburn/bootburn.sh -b p2382a00 -H $@
	elif [ "$ARG_BOARD" == "t186ref" ]; then
		ANDROID_TARGET_DEVICE=vcm31t186 eenv ./embedded/tools/scripts/t186_bootburn/bootburn.sh -b p2382-t186 -M -H $@
	else
		Usage
	fi
else
	Usage
fi

