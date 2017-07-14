#!/bin/bash
adb shell dumpsys SurfaceFlinger |grep "Display 0" -A 24
