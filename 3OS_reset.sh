#!/bin/bash
if [ "$#" -lt 3 ]; then
	echo "command: /home/ncho/bin/3OS_reset.sh <linux num> <qnx num> <android num>"
else
  /home/ncho/bin/phidget-ctrl.sh reset
  linux=/dev/pts/$1
  qnx=/dev/pts/$2
  android=/dev/pts/$3
  QNX_rootfs="/home/ncho/1T/NextEV/qnx/out/embedded-qnx-t186ref-release-none/target_rootfs"
  echo linux =$linux
  echo qnx =$qnx
  echo android =$android

  sleep 40 ## for waiting the android linux kernel boot up.
  #setup linux
  echo "sudo ifconfig eth0 up" > $linux
  echo "sudo ifconfig hv0 up" > $linux
  echo "sudo ifconfig hv2 up" > $linux
  echo "sudo brctl addbr br0" > $linux
  echo "sudo brctl addif br0 eth0" > $linux
  echo "sudo brctl addif br0 hv0" > $linux
  echo "sudo brctl addif br0 hv2" > $linux
  echo "sudo dhclient br0" > $linux

  ##QNX
  echo "dhcp.client hv0" > $qnx
  ubuntu_ip=`ifconfig eth1 |grep "inet addr" |awk '{print $2}' |sed 's/^.....//'`
  echo "fs-nfs3 -t $ubuntu_ip:$QNX_rootfs /" > $qnx
  echo ". ./setup.sh" > $qnx
  echo "screen" > $qnx
  echo "ifconfig hv1 192.168.0.1 netmask 255.255.255.0 up" > $qnx
  echo "/samples/opengles2/eglcrosspart/eglcrosspart -proctype consumer -latency 0 -timeout 0 -fifo 3 -dispno 1 -res 1920 1080 &" > $qnx

  sleep 1
  echo "su" > $android
  sleep 1
  echo "ifconfig hv1 down" > $android
  sleep 2
  echo "ifconfig hv1 up" > $android
  sleep 4
  echo 'ifconfig |grep "inet addr" |grep "10.19" ' > $android
  sleep 1 
  echo "saf775x_util bootFromRom" > $android
fi
