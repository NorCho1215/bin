function Usage()
{
	echo -e ""
	echo -e "\033[91mUsage:\033[0m"
	echo -e "\tsource /usr/local/bin/build_v4a.sh <board>" 
	echo -e "\t\t<board> can be 'vcm31t210ref' or 'vcm31t186ref'."
	echo -e ""
}

if [ "$1" != "vcm31t210ref" ] && [ "$1" != "vcm31t186ref" ]; then
	Usage
else
	if [ "$1" == "vcm31t186ref" ]; then
		export SECURE_OS_BUILD=n
	fi
	export TOP=`pwd`
	source build/envsetup.sh
	setpaths
	choosecombo 1 $1 3
	mp dev
fi

