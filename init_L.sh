NPC="10.19.106.171"

ifconfig eth0 up
dhclient eth0
su nvidia
sudo apt-get update
sudo apt-get install ssh tmux cron samba
sudo apt-get install android-tools-adb android-tools-fastboot
mkdir /home/ncho/bin -p
chown nvidia.nvidia /home/ncho/bin
mkdir /home/ncho/Projects/upload/FFBE -p
chown nvidia.nvidia /home/ncho/Projects/upload/FFBE
cp /usr/bin/adb /home/ncho/bin/adb
scp ncho@10.19.106.171:/home/ncho/bin/ffbe_rank.sh /home/ncho/bin/
sudo scp ncho@10.19.106.171:/home/ncho/bin/smb.conf.ubuntu /etc/samba/smb.conf
sudo scp ncho@10.19.106.171:/etc/vim/vimrc.tiny /etc/vim
sudo smbpasswd -a nvidia
sudo service smbd restart
sudo dpkg-reconfigure tzdata 
