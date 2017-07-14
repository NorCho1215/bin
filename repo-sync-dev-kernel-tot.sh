#!/bin/bash

function Usage()
{
	echo -e ""
	echo -e "Usage:"
	echo -e "\t$(basename $0) <suffix>"
	echo -e "\t\t<suffix> is suffix for local branch name"
	echo -e ""
}

TOP_PATH=`pwd`
SUFFIX=$1

if [ "$SUFFIX" = "" ]; then
	Usage
	exit 1
fi

REPO_PATH=( hardware/nvidia/platform/t18x/common
	    hardware/nvidia/platform/t18x/dragonfly
	    hardware/nvidia/platform/t18x/fpga
	    hardware/nvidia/platform/t18x/misc
	    hardware/nvidia/platform/t18x/quill
	    hardware/nvidia/platform/t18x/quill-dev
	    hardware/nvidia/platform/t18x/quill-internal
	    hardware/nvidia/platform/t18x/sim
	    hardware/nvidia/platform/t18x/sunstreaker
	    hardware/nvidia/platform/t18x/vcm
	    hardware/nvidia/platform/t19x/common
	    hardware/nvidia/platform/t19x/sim
	    hardware/nvidia/platform/t210/abca
	    hardware/nvidia/platform/t210/common
	    hardware/nvidia/platform/t210/ers
	    hardware/nvidia/platform/t210/foster
	    hardware/nvidia/platform/t210/fpga
	    hardware/nvidia/platform/t210/hawkeye
	    hardware/nvidia/platform/t210/jetson
	    hardware/nvidia/platform/t210/misc
	    hardware/nvidia/platform/t210/orca
	    hardware/nvidia/platform/t210/sim
	    hardware/nvidia/platform/t210/vcm
	    hardware/nvidia/platform/t210b01/abca
	    hardware/nvidia/platform/t210b01/common
	    hardware/nvidia/platform/t210b01/ers
	    hardware/nvidia/platform/t210b01/interposer
	    hardware/nvidia/platform/tegra/common
	    hardware/nvidia/soc/t18x
	    hardware/nvidia/soc/t19x
	    hardware/nvidia/soc/t210
	    hardware/nvidia/soc/tegra
	    kernel/t18x
	    kernel/kernel-4.4
            kernel/kernel-4.9
	    kernel/display
	    kernel/nvgpu
	    kernel/nvgpu-t19x
	    kernel/nvhost
	    kernel/nvhost-t19x
	    kernel/nvmap
	    kernel/nvmap-t18x
	    kernel/nvmap-t19x
	    kernel/t19x
	    kernel/kernel-shield-3.10
	    kernel/nvidia
	    kernel-build
	    vendor/nvidia/tegra/tests-kernel-ip
	    vendor/nvidia/tegra/tests-kernel
	    vendor/nvidia/tegra/tests-perf
	    vendor/nvidia/tegra/tests-plans/kernel
	    vendor/nvidia/tegra/tests-power )

NEED_TO_TERMINATE=0
for repo_path in ${REPO_PATH[@]}
do
	cd $TOP_PATH/$repo_path
	if [ "$?" != "0" ]; then
		exit 2
	fi
	if [ "`git status -s -uno`" != "" ]; then
		echo -e "\033[91m$repo_path is dirty\033[0m"
		NEED_TO_TERMINATE=1
	fi
done

if [ $NEED_TO_TERMINATE -ne 0 ]; then
	exit 3
fi

BRANCH_NAME=
for repo_path in ${REPO_PATH[@]}
do
	cd $TOP_PATH/$repo_path
	if [ "$?" != "0" ]; then
		exit 4
	fi
	if [ "$repo_path" = "kernel/kernel-next" ]; then
		BRANCH_NAME="dev-kernel-next"
	elif [ "$repo_path" = "kernel/kernel-3.10" -o "$repo_path" = "kernel/t18x" ]; then
		BRANCH_NAME="dev-kernel-3.10"
	elif [ "$repo_path" = "kernel/kernel-3.18" ]; then
		BRANCH_NAME="dev-kernel-3.18"
	elif [ "$repo_path" = "kernel/kernel-4.4" ]; then
		BRANCH_NAME="dev-kernel-4.4"
	elif [ "$repo_path" = "kernel/kernel-4.9" ]; then
		BRANCH_NAME="dev-kernel-4.9"
	else
		BRANCH_NAME="dev-kernel"
	fi
	git checkout -b $BRANCH_NAME-$SUFFIX origin/$BRANCH_NAME
	git pull origin $BRANCH_NAME
done

