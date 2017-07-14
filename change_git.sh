mirror_flag=$1

if [ "$1" == "Y" ];then
cp /home/ncho/.gitconfig.170315.nomirror /home/ncho/.gitconfig
echo "closed git mirror setting"
else
cp /home/ncho/.gitconfig.160718 /home/ncho/.gitconfig
echo "opened git mirror setting"
fi
exit 0;
