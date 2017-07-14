test ! -d root && test -f ramdisk.img && mkdir root && cd root && gunzip -c ../ramdisk.img | cpio -i && ls -l
if [ "$1" == "" ]; then
   test -d root && /home/ncho/1T/V4A_main/android/out/host/linux-x86/bin/mkbootfs root | gzip -9 > ramdisk.img && ls -l ramdisk.img
else
   test -d root && /home/ncho/1T/$1/android/out/host/linux-x86/bin/mkbootfs root | gzip -9 > ramdisk.img && ls -l ramdisk.img
fi

