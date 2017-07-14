#!/bin/bash
code_path="/home/ncho/1T"
folder_name=$1
project_name=$2
sync_C=$3
patch_script=$4
common_log_path=$code_path/${folder_name}/build_${folder_name}_$project_name.log
android_log_path=$code_path/${folder_name}/android/build_${folder_name}_$project_name.log
foundation_log_path=$code_path/${folder_name}/foundation/build_${folder_name}_$project_name.log
#echo common_log_path=$common_log_path
#echo android_log_path=$android_log_path
#echo foundation_log_path=$foundation_log_path
#functiona
function check_previous_tag(){
   if [ -d $code_path/${folder_name}/android/kernel ]; then
       cd $code_path/${folder_name}/android/kernel
   fi
   TAG_previous=`date -d -1day |awk '{print $6$2$3}'`
   TAG_result=`git tag |grep $TAG_previous`
   while [ "$TAG_result" == "" ] && [ "$i" -lt "365" ]
   do
        i=$(($i+1))
        TAG_previous=`date -d -${i}day |awk '{print $6$2$3}'`
        TAG_result=`git tag |grep $TAG_previous`
        echo TAG_previous=$TAG_previous i=$i result=`git tag |grep $TAG_previous`
   done
   history_tag;
}

function history_tag(){
  TAG_name=`date |awk '{print $6_$2_$3}'`
  echo history_tag= $TAG_previous
  Diff_log=$code_path/${folder_name}/change_list/$TAG_name.log
  echo "111 $TAG_result"
  TAG_result=`git tag |grep $TAG_previous`
  if [ "$result" == "" ]; then
    echo "get yesterday tag "
    if [ -d $code_path/${folder_name}/change_list ]; then
        touch $Diff_log
    else
        mkdir $code_path/${folder_name}/change_list
    fi
    cd $code_path/${folder_name}/android
    echo 
    /usr/local/bin/repo forall -c "pwd && git log $TAG_previous..HEAD" >> $Diff_log
    /usr/local/bin/repo forall -c "git tag $TAG_name"
    # example : git log 2015Sep6..2015Sep7
  else
    echo "don't get yesterday tag, create today tag for record"
    /usr/local/bin/repo forall -c "git tag $TAG_name"
  fi
}

#start point 
if [ "$#" -lt 3 ]; then
    echo "command: /home/ncho/daily_build.sh <folder> <project> <re-sync> <patch script name>"
else
    cd $code_path/${folder_name}
    echo `pwd` > $code_path/${folder_name}/build_${folder_name}_$project_name.log 2>&1
    echo "1111 Daily build process start" >> $common_log_path 2>&1
    echo `date` >> $common_log_path 2>&1
    if [ "$sync_C" == "N" ]; then
       echo "NNNNN"
       cd $code_path/${folder_name}/android/
       test -d .repo && echo "rm out" >> $common_log_path 2>&1
       test -d .repo && rm out -rf
       cd $code_path/${folder_name}/foundation/
       test -d .repo && echo "rm out" >> $common_log_path 2>&1
       test -d .repo && rm out -rf
    elif [ "$sync_C" == "Y" ]; then #clean build and sync code.
       echo "YYYY"
       ## delete all code with android
       cd $code_path/${folder_name}/android/
       test -d .repo && echo "Y1111 rm * -rf" >> $common_log_path 2>&1
       echo "Y2222 Daily build rm all finish -- android" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1
       test -d .repo && rm * -rf
       test -d .repo && /usr/local/bin/repo sync -cj8 --force-sync >> $common_log_path 2>&1
       echo "Y3333 Daily build clean or sync end -- android" >> $common_log_path 2>&1
       echo `date` >> build_${folder_name}_$project_name.log 2>&1
       echo "cscope and ctags end"  >> build_${folder_name}_$project_name.log 2>&1
       echo `date` >> build_${folder_name}_$project_name.log 2>&1
       check_previous_tag;
       echo "history_tag end"  >> build_${folder_name}_$project_name.log 2>&1
       echo `date` >> build_${folder_name}_$project_name.log 2>&1

       ## delete all code with foundation
       cd $code_path/${folder_name}/foundation/
       test -d .repo && echo "rm * -rf" >> $common_log_path 2>&1
       echo "Daily build rm all finish -- foundation" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1
       test -d .repo && rm * -rf
       test -d .repo && /usr/local/bin/repo sync -cj8 --force-sync >> $common_log_path 2>&1
       echo "Daily build clean or sync end -- foundation" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1

       ## delete all code with qnx
       test -d .repo && cd $code_path/${folder_name}/qnx/
       test -d .repo && echo "rm * -rf" >> $common_log_path 2>&1
       echo "Daily build rm all finish -- qnx" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1
       test -d .repo && rm * -rf
       test -d .repo && /usr/local/bin/repo sync -cj8 --force-sync >> $common_log_path 2>&1
       echo "Daily build clean or sync end -- qnx" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1

       ## delete all code with linux
       test -d .repo && cd $code_path/${folder_name}/linux/
       test -d .repo && echo "rm * -rf" >> $common_log_path 2>&1
       echo "Daily build rm all finish -- linux" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1
       test -d .repo && echo $passww | sudo -S rm * -rf
       test -d .repo && /usr/local/bin/repo sync -cj8 --force-sync >> $common_log_path 2>&1
       echo "Daily build clean or sync end -- linux" >> $common_log_path 2>&1
       echo `date` >> $common_log_path 2>&1
       ## patch code
       cd $code_path/${folder_name}/
       test -d $patch_script && $patch_script
    fi
    if [ "$sync_C" != "Y" ] && [ "$sync_C" != "N" ]; then 
        sleep $4
    fi

    ## Build qnx
    if [ -d $code_path/${folder_name}/qnx ]; then
        cd $code_path/${folder_name}/qnx
        test -d .repo && /home/ncho/bin/build_V4A_q.sh ${folder_name} $project_name
        echo "Daily build process End -- QNX" >> $common_log_path 2>&1
        echo `date` >> $code_path/${folder_name}/build_${folder_name}_$project_name.log 2>&1
    fi

    ## Build linux
    if [ -d $code_path/${folder_name}/linux ]; then
        cd $code_path/${folder_name}/linux
        test -d .repo && echo $passww | sudo -S /home/ncho/bin/build_V4A_l.sh ${folder_name} $project_name
        echo "Daily build process End -- LINUX" >> $common_log_path 2>&1
        echo `date` >> $code_path/${folder_name}/build_${folder_name}_$project_name.log 2>&1
    fi

    ## Build foundation
    cd $code_path/${folder_name}/foundation
    echo `pwd`
    test -d .repo && /home/ncho/bin/build_V4A_f.sh ${folder_name} $project_name
    echo "Daily build process End -- foundation" >> $common_log_path 2>&1
    echo `date` >> $code_path/${folder_name}/build_${folder_name}_$project_name.log 2>&1

    ## Build android
    cd $code_path/${folder_name}/android
    test -d .repo && /home/ncho/bin/build_V4A_a.sh ${folder_name} $project_name
    echo "Daily build process End -- android" >> $common_log_path 2>&1
    echo `date` >> $code_path/${folder_name}/build_${folder_name}_$project_name.log 2>&1
 
fi
