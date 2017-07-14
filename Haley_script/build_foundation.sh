
function Usage()
{
	echo -e ""
	echo -e "\033[91mUsage:\033[0m"
	echo -e "\tsource /usr/local/bin/build_foundation.sh <board> <bind partitions>" 
	echo -e "\t\t<board> can be 'vcm30t124', 'p1889ref', 't210ref' or 't186ref', etc."
	echo -e "\t\t<bind partitions> can be 'linux-pl', 'linux-linux-pl', 'android-pl', 'android-linux-pl' or 'native', etc."
	echo -e ""
}

if [ "$1" == "" ] || [ "$2" == "" ]; then
	Usage
elif [ "$2" == "native" ]; then
	source tmake/scripts/envsetup.sh
	choose embedded-foundation $1 none release
	tmp
else
	source tmake/scripts/envsetup.sh
	choose embedded-foundation $1 none release
	source foundation/mk_blob.sh
	export NV_BUILD_CONFIGURATION_IS_VERBOSE=1
	tmp
	tmp systemimage

	if [ "$1" == "t210ref" ]; then
		bind_partitions $2 -b p2382a00
	elif [ "$1" == "t186ref" ]; then
		bind_partitions $2 -b p2382-t186
	else
		bind_partitions $2
	fi
fi

