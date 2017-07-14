#!/bin/bash
: ${HOST_IP:=10.19.106.184}
: ${LOCAL_SOURCE_CODES_ROOT_PATH:=/home/ghsu/Sunstreaker/4.1.6.1/final_6/}

first_run=$1

if [ "$#" -lt 1 ]; then
    echo "command: android.sh <system first run Y/N>"
    echo "example: ./android.sh Y"
    exit
else
  echo $first_run
  if [ $first_run == "Y" ]; then
    echo "create new panes for Aurix & CCC"
     tmux new-window -a -n Aurix_1
     tmux new-window -a -n CCC_1
     tmux split-window -h
     tmux split-window -v
    echo "setup the uart console for Aurix & CCC"
     tmux send-key -t Aurix_1 "sudo minicom -D /dev/ttyUSBX" C-m  # UART port for Aurix
     tmux send-key -t Aurix_1 "Password for suduo" C-m
     tmux send-key -t CCC_1.0 "sudo minicom -D /dev/pts/XX" C-m   # Linux VM console
     tmux send-key -t CCC_1.0 "Password for sudo" C-m
     tmux send-key -t CCC_1.1 "sudo minicom -D /dev/pts/XX" C-m   # QNX VM console
     tmux send-key -t CCC_1.1 "Password for sudo" C-m
     tmux send-key -t CCC_1.2 "sudo minicom -D /dev/pts/XX" C-m   # Android VM console
     tmux send-key -t CCC_1.2 "Password for sudo" C-m
   sleep 10
  fi

echo "Poweroff/PowerOn P2379"
tmux send-key -t Aurix_1.0 "poweroff" C-m
sleep 2
tmux send-key -t Aurix_1.0 "poweron" C-m
sleep 35

echo "Initial Audio in Linux"
tmux send-key -t CCC_1.0 "sudo su" C-m
tmux send-key -t CCC_1.0 "nvidia" C-m
sleep 1
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='MIXER1-1 Mux' 'None'" C-m
sleep 5
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='MIXER1-2 Mux' 'None'" C-m
sleep 5
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S1 Loopback' '1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S2 Loopback' '1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S3 Loopback' '1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S4 Loopback' '1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF5 Mux' 'ADX1-1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF6 Mux' 'ADX1-2'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADX1 Mux' 'I2S4'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S4 Mux' 'AMX1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX1-1 Mux' 'ADMAIF2'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX1-2 Mux' 'ADMAIF9'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF2 Mux' 'ADX2-1'" C-m
sleep 10
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF9 Mux' 'ADX2-2'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADX2 Mux' 'I2S3'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S3 Mux' 'AMX2'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX2-1 Mux' 'ADMAIF5'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX2-2 Mux' 'ADMAIF6'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF1 Mux' 'ADX3-1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADX3 Mux' 'I2S1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S1 Mux' 'AMX3'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX3-1 Mux' 'ADMAIF10'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADMAIF10 Mux' 'ADX4-1'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='ADX4 Mux' 'I2S2'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='I2S2 Mux' 'AMX4'" C-m
sleep 2
tmux send-key -t CCC_1.0 "amixer -c 0 cset name='AMX4-1 Mux' 'ADMAIF1'" C-m

echo "Print slog2info in QNX console"
tmux send-key -t CCC_1.1 "slog2info -w &" C-m
echo "Mount Necessary folder in QNX console"
tmux send-key -t CCC_1.1 "fs-nfs3 -vv -t $HOST_IP:$LOCAL_SOURCE_CODES_ROOT_PATH/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le /qnx7-aarch64le" C-m
tmux send-key -t CCC_1.1 "fs-nfs3 -t -b 1000 -B 32768 $HOST_IP:$LOCAL_SOURCE_CODES_ROOT_PATH/vibrante-t186ref-qnx /root" C-m
tmux send-key -t CCC_1.1 "fs-nfs3 -t $HOST_IP:$LOCAL_SOURCE_CODES_ROOT_PATH /host" C-m

echo "Export PATH in QNX"
tmux send-key -t CCC_1.1 "export PATH=/proc/boot:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/usr/lib/:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/usr/bin/:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/usr/sbin/:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/bin/:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/sbin:/qnx7-aarch64le/sbin/:/host/qnx/deferred_packaging/qa/vibrante-t186ref-qnx/qa/:/host/qnx/test/_out/release_t186ref-qnx/_armv6:/root/qa/ccp/server/bin:$PATH" C-m
tmux send-key -t CCC_1.1 "export LD_LIBRARY_PATH=/proc/boot:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/lib:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/usr/lib:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/sbin:/root/bin-target:/root/bsp/install/aarch64le/lib/dll/:/host/qnx_toolchains/qnx_toolchain/target/qnx7/aarch64le/lib/dll:/root/lib-target:/root/lib-target/screen/:/qnx7-aarch64le/lib/:/qnx7-aarch64le/usr/lib/:/host/qnx/test/_out/release_t186ref-qnx/_armv6:/root/qa/ccp/server/lib:/host/" C-m
tmux send-key -t CCC_1.1 "export GRAPHICS_ROOT=/root/utils/scripts/screen/" C-m
sleep 2

echo " run screen in QNX"
tmux send-key -t CCC_1.1 "screen" C-m
sleep 2

echo " initial audio in QNX"
tmux send-key -t CCC_1.1 "export NV_IO_AUDIO_MULTIOS=5" C-m
sleep 1
tmux send-key -t CCC_1.1 "io-audio -d tegra-tx1_virt nv_conf=/root/qa/audio/confs/t186_virt2.conf,guest_id=2" C-m
sleep 2

echo "Launch ccp_server in QNX"
tmux send-key -t CCC_1.1 "cd /root/qa/ccp/server/bin/" C-m
tmux send-key -t CCC_1.1 "./ccp_server -c server.conf -d 1 &" C-m
sleep 10

echo "Run 2 dumy graphic Apps"
tmux send-key -t CCC_1.1 "cd /root/samples/opengles2/gears/screen" C-m
tmux send-key -t CCC_1.1 "./gears -1 &" C-m
sleep 3
tmux send-key -t CCC_1.1 "cd /root/samples/opengles2/bubble/screen" C-m
tmux send-key -t CCC_1.1 "./bubble &" C-m

echo "Launch Android EGL"
sleep 2
tmux send-key -t CCC_1.1 "/root/samples/opengles2/eglcrosspart/screen/eglcrosspart -proctype consumer -latency 0 -timeout 0 -fifo 3 -res 1920 1080 &" C-m

fi
