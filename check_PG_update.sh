#!/bin/bash
cd /home/ncho/Projects/upload/Nvbug/PG/audio_check
rm * -rf 
git clone git@git.pelagicore.net:NVIDIA/drivecx_dirana3.git
cd ~/1T/PG_git
repo sync -cj8
