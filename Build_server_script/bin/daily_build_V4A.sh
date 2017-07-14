#!/bin/bash
i=0
code_path="/home/autotw/work/source"
folder_name=$1
project_name=$2
BASE_folder=${code_path}/${folder_name}
common_log_path=${BASE_folder}/build_${folder_name}_$project_name.log
android_log_path=${BASE_folder}/android/build_${folder_name}_$project_name.log
foundation_log_path=${BASE_folder}/foundation/build_${folder_name}_$project_name.log
Share_folder="/home/autotw/work/share/$folder_name"
##
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export P4ROOT="/home/autotw/p4"
#echo common_log_path=$common_log_path
#echo android_log_path=$android_log_path
#echo foundation_log_path=$foundation_log_path

#function
function history_tag(){
  echo " history_tag start" >> $common_log_path 2>&1
  TAG_name=`date |awk '{print $6_$2_$3}'`
  echo history_tag= $1
  Diff_log=${BASE_folder}/change_list/$TAG_name.log
  echo "111 $TAG_result"
  TAG_result=`git tag |grep $TAG_previous`
  if [ "$TAG_result" != "" ]; then
    echo "get yesterday tag "
    if [ -d ${BASE_folder}/change_list ]; then
        touch $Diff_log
    else
        mkdir ${BASE_folder}/change_list
    fi
    cd ${BASE_folder}/android
    echo 
    /usr/local/bin/repo forall -c "pwd && git log $TAG_previous..HEAD" >> $Diff_log
    /usr/local/bin/repo forall -c "git tag $TAG_name"
    # example : git log 2015Sep6..2015Sep7
  else
    echo "don't get yesterday tag, create today tag for record"
    /usr/local/bin/repo forall -c "git tag $TAG_name"
  fi
  echo " history_tag end" >> $common_log_path 2>&1
  echo " manifest start" >> $common_log_path 2>&1
  if [ -d ${BASE_folder}/manifest.xml ]; then
        cd ${BASE_folder}/android
        echo "manifest start"
        echo `pwd` >> $common_log_path 2>&1
        test -d .repo && /usr/local/bin/repo manifest -o ${BASE_folder}/manifest.xml/android_${TAG_name}.xml -r
        echo "has folder and create a manifest android_$TAG_name.xml" >> $common_log_path 2>&1
        test -f ${BASE_folder}/manifest.xml/android_${TAG_name}.xml && echo "create ${TAG_name} manifest success!!!" >> $common_log_path 2>&1
  else
        mkdir ${BASE_folder}/manifest.xml
        cd ${BASE_folder}/android
        echo `pwd` >> $common_log_path 2>&1
        test -d .repo && /usr/local/bin/repo manifest -o ${BASE_folder}/manifest.xml/android_${TAG_name}.xml -r
        echo "no folder and create folder & manifest android_$TAG_name.xml" >> $common_log_path 2>&1
        test -f ${BASE_folder}/manifest.xml/android_${TAG_name}.xml && echo "create ${TAG_name} manifest success!!!" >> $common_log_path 2>&1
  fi
  echo " manifest end" >> $common_log_path 2>&1
}

function check_previous_tag(){
   if [ -d ${BASE_folder}/android/kernel ]; then
       cd ${BASE_folder}/android/kernel
   fi
   while [ "$TAG_result" == "" ] && [ "$i" != "2" ]
   do
        i=$(($i+1))
        TAG_previous=`date -d -${i}day |awk '{print $6$2$3}'`
        TAG_result=`git tag |grep $TAG_previous`
        
        echo TAG_previous=$TAG_previous i=$i result=$TAG_result
   done
   echo "result=$TAG_result"
   history_tag $TAG_result
   echo "history_tag end"  >> $common_log_path 2>&1
   echo `date` >> $common_log_path 2>&1
}

function clean_sync_android(){
  cd ${BASE_folder}/android/
  test -d .repo && echo "Y1111 rm * -rf" >> $common_log_path 2>&1
  echo "Y2222 Daily build rm all finish -- android" >> $common_log_path 2>&1
  echo `date` >> $common_log_path 2>&1
  test -d .repo && rm * -rf
  test -d .repo && /usr/local/bin/repo sync -f -cj4 >> $common_log_path 2>&1
  echo "Y3333 Daily build clean or sync end -- android" >> $common_log_path 2>&1
  echo `date` >> $common_log_path 2>&1
}

function clean_sync_foundation(){
  cd ${BASE_folder}/foundation/
  test -d .repo && echo "rm * -rf" >> $common_log_path 2>&1
  echo "Daily build rm all finish -- foundation" >> $common_log_path 2>&1
  echo `date` >> $common_log_path 2>&1
  test -d .repo && rm * -rf
  test -d .repo && /usr/local/bin/repo sync -f -cj4 >> $common_log_path 2>&1
  echo "Daily build clean or sync end -- foundation" >> $common_log_path 2>&1
  echo `date` >> $common_log_path 2>&1
}

function backup_image(){
    ## Backup image and share
    bacup_name=`date |awk '{print $6_$2_$3}'`
    cd ${BASE_folder}
    echo "Daily build Back up image start" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
    test ! -d ${Share_folder}/image/ && echo "No share foler" && mkdir ${Share_folder}/image/ -p
    # don't package obj  obj_arm  system
    out_target=`echo $project_name | cut -c 1-9`
    mv ${BASE_folder}/android/out/target/product/$out_target/obj ${BASE_folder}/android/out/target/product/
    mv ${BASE_folder}/android/out/target/product/$out_target/obj_arm ${BASE_folder}/android/out/target/product/
    mv ${BASE_folder}/android/out/target/product/$out_target/system ${BASE_folder}/android/out/target/product/
    tar -zcf ${Share_folder}/image/${bacup_name}_${project_name}.tgz ${BASE_folder}/android/out/target/product/$out_target ${BASE_folder}/foundation
    test ! -d ${BASE_folder}/build_log && echo "No build log folder" && mkdir ${BASE_folder}/build_log -p
    cp ${BASE_folder}/android/build_${folder_name}_${project_name}_${bacup_name}.log ${BASE_folder}/build_log/android_${folder_name}_${project_name}.log
    cp ${BASE_folder}/foundation/build_${folder_name}_${project_name}_${bacup_name}.log ${BASE_folder}/build_log/foundation_${folder_name}_${project_name}.log
    cp -rf ${BASE_folder}/change_list ${BASE_folder}/manifest.xml ${BASE_folder}/build_log $Share_folder
    echo "Daily build Back up image End" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
}

function build_image(){
    echo "function build_image"
    ## Build foundation
    cd ${BASE_folder}/foundation
    echo `pwd`
    echo "Daily build process Start -- foundation" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
    test -d .repo && /home/autotw/bin/build_V4A_f.sh ${folder_name} $project_name
    echo "Daily build process End -- foundation" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
    ## Build android
    cd ${BASE_folder}/android
    echo "Daily build process Start -- android" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
    test -d .repo && /home/autotw/bin/build_V4A_a.sh ${folder_name} $project_name
    echo "Daily build process End -- android" >> $common_log_path 2>&1
    echo `date` >> ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
}

function check_image(){
    previous_date=`date -d -32day |awk '{print $6_$2_$3}'`
    rm -rf ${Share_folder}/image/${previous_date}_${project_name}.tgz
}

#start point ### main
if [ "$#" -lt 3 ]; then
    echo "command: /home/autotw/bin/daily_build.sh <folder> <project> <re-sync>"
else
    cd ${BASE_folder}
    echo `pwd` > ${BASE_folder}/build_${folder_name}_$project_name.log 2>&1
    echo "1111 Daily build process start" >> $common_log_path 2>&1
    echo `date` >> $common_log_path 2>&1
    if [ "$3" == "N" ]; then
       echo "NNNNN"
       cd ${BASE_folder}/android/
       test -d .repo && echo "rm out" >> $common_log_path 2>&1
       test -d .repo && rm out -rf
       cd ${BASE_folder}/foundation/
       test -d .repo && echo "rm out" >> $common_log_path 2>&1
       test -d .repo && rm out -rf
    elif [ "$3" == "Y" ]; then #clean build and sync code.
       echo "YYYY"
       ## delete all code with android
       clean_sync_android;
       ## delete all code with foundation
       clean_sync_foundation;
       check_previous_tag;
    fi
    if [ "$3" != "Y" ] && [ "$3" != "N" ]; then 
        sleep $4
    fi
    echo "build_image"
    build_image;
    echo "backup_image"
    backup_image;
    echo "check_image"
    check_image;
fi
