#! /usr/bin/env python
# Copyright (c) 2014, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

import commands, sys, re
from utils import *

def get_board():
    r = cmd('adb shell cat /proc/cpuinfo | grep Hardware | dos2unix')
    if 'error' in r:
        print 'no adb access'
        return None

    board = r.split()[-1].replace(' ', '_')
    if board == 't132ref':
        board = 'norrin'
    if board == 'tn8':
        board = 'e1765'
    return board

def get_image():
    res = cmd("adb shell dumpsys dropbox | grep Build | grep -v Process")
    if 'error' in res:
        print 'no adb access'
        return None

    try:
        l = res.split('\n')[0]
        img = l.split()[1]
        return img
    except:
        return ''

def get_resolution():
    res = cmd("adb shell dumpsys window | grep mUnrestrictedScreen | sed 's/^.* //'")
    if 'error' in res:
        print 'no adb access'
        return None

    t = res.split('x')
    if len(t) != 2:
        print 'error'
        return None

    return str(max(int(t[0]), int(t[1]))) + 'x' + str(min(int(t[0]), int(t[1])))

def get_speedo_iddq():
    res = ash("powersig --time 0")
    if 'error' in res:
        print 'no adb access'
        return None

    cpu_speedo = None
    gpu_speedo = None
    soc_speedo = None
    cpu_iddq = None
    gpu_iddq = None
    soc_iddq = None

    for l in res.split('\n'):
        l = l.lower()
        if 'cpu speedo' in l:
            cpu_speedo = int(l.split()[-1])
        if 'gpu speedo' in l:
            gpu_speedo = int(l.split()[-1])
        if 'soc speedo' in l:
            soc_speedo = int(l.split()[-1])
        if 'cpu iddq' in l:
            cpu_iddq = int(l.split()[-1])
        if 'gpu iddq' in l:
            gpu_iddq = int(l.split()[-1])
        if 'soc iddq' in l:
            soc_iddq = int(l.split()[-1])

    res = ''
    if cpu_speedo and cpu_iddq:
        res += 'cpu:' + str(cpu_speedo) + '/' + str(cpu_iddq) + ' '
    if gpu_speedo and gpu_iddq:
        res += 'gpu:' + str(gpu_speedo) + '/' + str(gpu_iddq) + ' '
    if soc_speedo and soc_iddq:
        res += 'soc:' + str(soc_speedo) + '/' + str(soc_iddq) + ' '
    return res

def get_max_freqs():
    if cmd('adb get-state') != 'device':
        print 'no adb access'
        return None

    r = ash('cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies')
    cpu = int(r.split()[-1])/1000

    r = ash('cat /d/clock/gbus/max')
    if 'No such' in r:
        r = ash('cat /d/clock/c2bus/possible_rates')
        gpu = int(r.split()[-2])/1000
    else:
        gpu = int(r)/1000000

    r = ash('cat /d/clock/emc/max')
    emc = int(r.rstrip())/1000000

    return 'CPU ' + str(cpu) + ' GPU ' + str(gpu) + ' EMC ' + str(emc)

def get_mts_version():
    if commands.getoutput('adb get-state') != 'device':
        print 'no adb access'
        return None

    try:
        res = cmd('adb shell cat /proc/cpuinfo | grep MTS').rstrip().split()[-1]
        if 'error' in res:
            return ''
        else:
            return 'MTS-' + res
    except:
        return ''

def get_frt():
    try:
        ussrdtarget = int(getprop("phs.frt.override"))
    except:
        ussrdtarget = 0
    if ussrdtarget == 0:
        ussrdtarget = 60
    try:
        fpslimit = int(getprop("persist.sys.NV_FPSLIMIT"))
    except:
        fpslimit = 60
    if fpslimit == 0:
        fpslimit = 60
    overall = min(fpslimit, ussrdtarget)
    return overall

def get_temperature():
    cpu_temp = 0.0
    skin_temp = 0.0
    try:
        cpu_pth = getprop("NV_THERM_CPU_TEMP")
        if cpu_pth and len(cpu_pth) > 1:
            cpu_temp = float(ash("cat " + cpu_pth))/1000.0
    except:
        pass
    try:
        skin_pth = getprop("NV_THERM_SKIN_TEMP")
        if skin_pth and len(skin_pth) > 1:
            skin_temp = float(ash("cat " + skin_pth))/1000.0
    except:
        pass
    return (cpu_temp, skin_temp)

