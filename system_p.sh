mv $OUT/system.img $OUT/system.img.olg && make_ext4fs -s -T -1 -S $OUT/root/file_contexts -l 4261113856 -a system $OUT/system.img $OUT/system
