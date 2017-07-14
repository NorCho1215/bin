function Usage()
{
	echo -e ""
	echo -e "\033[91mUsage:\033[0m"
	echo -e "\tsource /usr/local/bin/build_v4q.sh <board>" 
	echo -e "\t\t<board> can be 'vcm31t210' or 't186ref'."
	echo -e ""
}

if [ "$1" != "vcm31t210" ] && [ "$1" != "t186ref" ]; then
	Usage
else
	source tmake/scripts/envsetup.sh

	if [ "$1" == "vcm31t210" ]; then
		choose embedded-qnx vcm31t210 v4q release internal
	elif [ "$1" == "t186ref" ]; then
		choose embedded-qnx t186ref none release internal
	fi

	export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
	tmp
	tmp systemimage
	image create_rootfs
fi

