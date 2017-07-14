LOCAL_PATH := $(call my-dir)

FileList := $(notdir $(wildcard $(LOCAL_PATH)/*.py))
Folder := $(notdir $(LOCAL_PATH:%/=%))

$(call nv-add-files-to-test,nvidia_tests/host/$(strip $(Folder)),$(FileList),BOARDAUTOMATION)
