#!/bin/bash
if [ "$1" != "" ]; then
  adb shell cat /sys/kernel/debug/regmap/tegra210-i2s.1/registers 2>&1 |tee $1
  echo "end ========i2s.1=========" 2>&1 |tee -a $1
  adb shell cat /sys/kernel/debug/regmap/tegra210-i2s.2/registers 2>&1 |tee -a $1
  echo "end ========i2s.2=========" 2>&1 |tee -a $1
  adb shell cat /sys/kernel/debug/regmap/tegra210-i2s.3/registers 2>&1 |tee -a $1
  echo "end ========i2s.3=========" 2>&1 |tee -a $1
  adb shell cat /sys/kernel/debug/regmap/tegra210-i2s.4/registers 2>&1 |tee -a $1
  echo "end ========i2s.4=========" 2>&1 |tee -a $1
  adb shell cat /sys/kernel/debug/regmap/tegra210-i2s.5/registers 2>&1 |tee -a $1
  echo "end ========i2s.5=========" 2>&1 |tee -a $1 
  adb shell cat /sys/kernel/debug/regmap/tegra210-sfc.0/registers 2>&1 |tee -a $1
  echo "end ========sfc.0=========" 2>&1 |tee -a $1
else
  echo $1=???!!!!!!
fi
