sudo umount ~/.public
#sudo umount ~/.toolchain
sudo umount /home/ncho/1T
#sudo umount /home/ncho/Projects/upload/3T
sudo mount.cifs //netapp-TW/public/Nor ~/.public -o username=ncho,password=$passnn,uid=ncho,gid=ncho
#sudo mount.cifs //netapp39/linuxbuilds/daily/Embedded/BuildBrain ~/.toolchain -o username=ncho,password=$passnn,uid=ncho,gid=ncho
#sudo fsck -yc /dev/sdb1
sudo mount /dev/sdb1 /home/ncho/1T
#sudo mount /dev/sda1 /home/ncho/Projects/upload/3T
#sudo chown ncho.ncho /home/ncho/Projects/upload/3T

