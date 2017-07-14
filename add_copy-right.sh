#!/bin/bash

Copyright_list=$1

list_data=`cat $Copyright_list |grep Copyright -B1 |grep File |awk '{print $2}'`
 
for list_name in $list_data
do
        echo " $list_name"
## add the nvidia copy right for all file.
        extract_name=${list_name##*.}
        filename=`echo $extract_name |awk -F "/" '{ print $NF }'`
        filename="${filename%.*}"
        echo "filename=$filename"
        echo "extract_name=$extract_name"
        if [ "${extract_name}" == "mk" ] || [ "${extract_name}" == "cfg" ] || [ "${filename}" == "Makefile" || [ "${extract_name}" == "md" ]; then
             #echo "11111"
sed -i '1i\
#\
# Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.\
#\
# NVIDIA Corporation and its licensors retain all intellectual property and\
# proprietary rights in and to this software and related documentation.  Any\
# use, reproduction, disclosure or distribution of this software and related\
# documentation without an express license agreement from NVIDIA Corporation\
# is strictly prohibited.\
#' $list_name
             
        else
             #echo "22222"
sed -i '1i\
/*\
 * Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.\
 *\
 * NVIDIA CORPORATION and its licensors retain all intellectual property\
 * and proprietary rights in and to this software, related documentation\
 * and any modifications thereto.  Any use, reproduction, disclosure or\
 * distribution of this software and related documentation without an express\
 * license agreement from NVIDIA CORPORATION is strictly prohibited.\
*/' $list_name

        fi
##

done

exit 0
####-----------------------------------------------------------------
sed -i '1i\
/*\
 * Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.\
 *\
 * NVIDIA CORPORATION and its licensors retain all intellectual property\
 * and proprietary rights in and to this software, related documentation\
 * and any modifications thereto.  Any use, reproduction, disclosure or\
 * distribution of this software and related documentation without an express\
 * license agreement from NVIDIA CORPORATION is strictly prohibited.\
*/' $list_name


sed -i '1i\
# Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA Corporation and its licensors retain all intellectual property and
# proprietary rights in and to this software and related documentation.  Any
# use, reproduction, disclosure or distribution of this software and related
# documentation without an express license agreement from NVIDIA Corporation
# is strictly prohibited.
#' $list_name

