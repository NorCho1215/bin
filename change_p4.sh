mirror_flag=$1

if [ "$1" == "sys" ];then
cp /home/ncho/bin/.p4config_sys /home/ncho/.p4config
echo "Set to sys p4"
else
cp /home/ncho/bin/.p4config /home/ncho/.p4config
echo "Set to SW p4"
fi
exit 0;
