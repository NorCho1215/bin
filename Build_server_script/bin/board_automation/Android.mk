#Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
LOCAL_PATH := $(call my-dir)

include $(NVIDIA_DEFAULTS)
LOCAL_MODULE := board_automation
LOCAL_IS_HOST_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := $(notdir $(LOCAL_PATH:%/=%))
LOCAL_NVIDIA_FIND_FILTER := -name '*.py'
LOCAL_SRC_FILES := .
include $(NVIDIA_TEST_FILES)
