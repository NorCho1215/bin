#!/bin/bash
if [  "$#" -lt 2 ]; then
    echo  "command: test_stress.sh <FILE_NAME> <media_folder> <count> <special>"
    adb shell ls /storage/
    exit 0
fi

stress_log=$1
folder_name=$2
count=$3
special=$4
k=0

p4 sync -f //sw/apps/embedded/autosan/apks/Automation/23/...
adb install -r /home/ncho/Projects/upload/p4/sw/apps/embedded/autosan/apks/Automation/23/NvMediaStressTest.apk
adb logcat -v time > ${stress_log}_logcat.log &
while [  "$k" != "$count" ]
do
echo  "=========== stress test $k ===============" >> $stress_log
echo  "=========== stress test $k ===============" >> ${stress_log}_logcat.log

if [ "$special" == "TS_h264_aac-plus_2" ]; then
adb shell "am instrument -e filename  /storage/${folder_name}/TS_h264_aac-plus_2.ts -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
else

adb shell  "am instrument -e filename /storage/${folder_name}/Selena-Gomez_H264_HP_L2.2_480i_CABAC_2Mbps.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log

adb shell  "am instrument -e filename /storage/${folder_name}/Selena-Gomez_H264_HP_L2.2_480i_CABAC_2Mbps.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename /storage/${folder_name}/NVIDIA_h264_MP_L3.1_720p_CAVLC_4M_aac.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename /storage/${folder_name}/NVIDIA_H264_MP_L3.1_480P_WP_CAVLC_4Mbps.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/NVIDIA_h264_HP_L3.1_720p_CAVLC_4M_aac.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/NVIDIA_h264_HP_L3.1_720p_CABAC_4M_aac.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/NVIDIA_H264_HP_L3.1_480P_WP_CABAC_4Mbps.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MKV_h264_eaac-plus_5mbs.mkv -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/vimeo_Mpeg2-mp-hl_1080p_40Mbps_30fps.ts -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/vimeo_Mpeg2-mp-hl_1080i_40Mbps_60i.ts -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/TS_h264_aac-plus_2.ts -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/trans_skate_mpeg4_1080_30_10M.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/TEGRA_h264_hp_1080i_20M_60i_aac.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/sony_h264_hp_D1_30_3M.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/rush_hour_1080p_SP_24fps_10M.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MOV_mpeg4_amr-nb_1.mov -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MOV_h264_aac-lc_1.mov -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MOV_h263_amr-wb_1.mov -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MKV_xvid_mp3_1.mkv -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MKV_mpeg4_aac+_1.mkv -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MKV_h264_eaac-plus_1.mkv -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/MKV_divx_aac-lc_2.mkv -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/medusa_vfr_H.264-mp_1280x720_24fps_15Mbps.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/H.264_MP_1080p_Cavlc_WP.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/H.264_HP_1080p_Cabac_WP.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/H.264-hp_720p_60fps_10Mbps.MP4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/casino_royal_Mpeg4_720p_6M_30fps_AACLC_256Kbps_48Khz.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/birds_h264_1080_20mbps_30fps.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/VP8_3480x2160_30mbps_30fps.webm -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/h265_3840x2160_high_20mbps_60fps.mp4 -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
adb shell "am instrument -e filename  /storage/${folder_name}/VP9_3840x2160_60mbps_60fps.webm -e class com.nvidia.nvmediafwktest.MediaPlayerStressTest#testPlaybackSingle -w com.nvidia.nvmediafwktest/.MediaPlayerStressTestRunner"  2>&1 >> $stress_log
fi

k=$(($k+1))
done

exit 0
