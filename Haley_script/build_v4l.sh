function Usage()
{
	echo -e ""
	echo -e "\033[91mUsage:\033[0m"
	echo -e "\tsource /usr/local/bin/build_v4l.sh <board>" 
	echo -e "\t\t<board> can be 't210ref' or 't186ref'."
	echo -e ""
}

if [ "$1" != "t210ref" ] && [ "$1" != "t186ref" ]; then
	Usage
else
	source tmake/scripts/envsetup.sh
	choose embedded-linux $1 none release internal aarch64
	export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
	tmp
	tmp systemimage
	image create_rootfs
fi

