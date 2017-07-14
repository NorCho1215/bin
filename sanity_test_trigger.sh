#!/bin/bash
i=0
sanity_output_path=$1
os=$2
note=$3
count=$4
file_name=$5
if [ "$#" -lt 4 ]; then
    echo "command: /home/ncho/bin/sanity_test_trigger.sh <sanity_output.tgz path> <which os android/embedded-android-hv> <which_test ap_video/ap_audio/ap_stagefright/MM_all> <how many runs> <file_name>"
    echo "e.g: /home/ncho/bin/sanity_test_trigger.sh xxx/sanity_output.tgz embedded-android-hv ap_audio 200 ap_audio_200"
else

  while [ "$i" != "$count" ]
  do
    i=$(($i+1))
    if [ "$note" == "ap_video" ]; then
      echo "==== ap_video count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o android -t ap_video -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
    elif [ "$note" == "ap_audio" ]; then
      echo "==== ap_audio count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_audio -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
    elif [ "$note" == "ap_stagefright" ]; then
      echo "==== ap_stagefright count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_stagefright -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
    elif [ "$note" == "ap_systemsw" ]; then
      echo "==== ap_stagefright count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_systemsw -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
    elif [ "$note" == "MM_all" ]; then
      echo "==== ap_video count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_video -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
      echo "==== ap_audio count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_audio -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
      echo "==== ap_stagefright count=$i ====" |tee -a ${note}_$file_name
      vrlsubmit -s ausvrl -u ncho -z $sanity_output_path -o $os -t ap_stagefright -c p2382-10 -r email -n $note |tee -a ${note}_$file_name
    else
      echo " test don't include in this script !! $note"
      exit
    fi

  done
fi
