export TOP=$(pwd) && export SECURE_OS_BUILD=n && . build/envsetup.sh && setpaths && choosecombo 1 vcm31t186ref 3
mv $OUT/system.img $OUT/system.img.$1 && make_ext4fs -s -T -1 -S $OUT/root/file_contexts -l 4261113856 -a system $OUT/system.img $OUT/system
