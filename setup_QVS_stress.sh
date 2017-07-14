#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "command: /home/ncho/bin/setup_QVS_stress.sh <run/setup> <run hour> <UART port> "
    echo "example command: /home/ncho/bin/setup_QVS_stress.sh run 2 /dev/ttyUSB0"
    exit 0
fi

if [ "$1" == "run" ]; then
cd ~/gitsrc/tools/qvs/stress/tests/stability/
sudo cp $P4ROOT/sw/apps/embedded/autosan/Scripts/stability/stress_common.py .
sudo cp $P4ROOT/sw/apps/embedded/autosan/Scripts/test_case_plugin.py ../dbapi/
python test_multimedia.py -d $2 --test_module audiostress --testplan 4307 --testid 92076 --uart_port $3 --seed 0
python test_multimedia.py -d $2 --test_module videostress --testplan 4307 --testid 92079 --uart_port $3 --seed 0
else
  if [ -d ~/gitsrc/tools ]; then
    cd ~/gitsrc/tools
    repo init -u git://git-master/tools/testing/qvs/manifest.git
    repo sync
  else
    mkdir -p ~/gitsrc/tools
    echo "run again"
  fi
fi
