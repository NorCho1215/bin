#! /usr/bin/env python
# Copyright (c) 2014, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

import subprocess, math, time, sys, datetime
from datetime import datetime

def average(l):
    if not l or len(l) == 0:
        return 0.0
    return (sum(l)/len(l))

def stddev(l):
    avg = average(l)
    var = map(lambda x: (x-avg)**2, l)
    res = math.sqrt(average(var))
    return res

def cmd(c, wait=True, noisy=False):
    if not wait:
        process = subprocess.Popen(c, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        return

    if noisy:
        process = subprocess.Popen(c, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        output = ''
        while True:
            nextline = process.stdout.readline()
            if nextline == '' and process.poll() != None:
                break
            output += nextline
            sys.stdout.write(nextline)
            sys.stdout.flush()
        return output.rstrip()
    else:
        process = subprocess.Popen(c, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
        output = process.communicate()[0]
        return output.rstrip()

def ash(c, wait=True, noisy=False):
    fullcmd = 'adb shell "' + c + '"'
    return cmd(fullcmd, wait=wait, noisy=noisy)

def getprop(prop):
    return ash('getprop ' + prop, wait=True, noisy=False)

def noisy_sleep(duration, tag=''):
    start = datetime.now()
    while True:
        time.sleep(1)
        left = duration - seconds_between(start, datetime.now())
        if left <= 0:
            break
        hrs = int(left / 3600)
        mins = int((left / 60) % 60)
        secs = left % 60
        flushprint(tag + ' ' + '%02d' % hrs + ':' + '%02d' % mins + ':' + '%02d' % secs)
    flushprint('                                                ')
    print ''

def flushprint(l):
    sys.stdout.write("\r" + str(l) + "                   ")
    sys.stdout.flush()

def seconds_between(da, db):
    return (db - da).seconds

def termcode(num):
    return '\033[%sm'%num

def red_str(txt):
    return termcode(91) + txt + termcode(0)

def yellow_str(txt):
    return termcode(93) + txt + termcode(0)

def print_error(s, fatal=False):
    print red_str('\n[ERROR] ' + s + '\n')
    if fatal:
        sys.exit(1)

def print_warning(s):
    print yellow_str('\n[WARNING] ' + s + '\n')
