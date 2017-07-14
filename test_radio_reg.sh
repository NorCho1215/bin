#!/bin/bash
function set_Freq_Mode(){
        CHANNEL_F=${1}
        Set_Freq=${2}
        Set_BAND=${3}
        #reg 01~02 or 61~62
        F_Freq_REG_1=`echo "obase=16;$Set_Freq"|bc`
        F_Freq_REG_2=`echo $F_Freq_REG_1|cut -c 3-4`
        F_Freq_REG_1=`echo $F_Freq_REG_1|cut -c 1-2`
        BASE=$(($CHANNEL_F*16#60))
        Set_MODE=$(($((2#10000))+$Set_BAND))
        Set_MODE=`echo "obase=16;$Set_MODE"|bc`
        VAL_REG=`echo "0x${Set_MODE}${F_Freq_REG_1}${F_Freq_REG_2}"`
        adb shell saf775x_util write $BASE $VAL_REG 3
}
## Release #26 add the noise scanner
i=0
if [ "$#" -lt 2 ]; then
    echo "Read command:  test_radio_reg.sh <R> <register>  <length> <count>"
    echo "Write command: test_radio_reg.sh <W> <file_name>"
    echo "noise scanner: test_radio_reg.sh <S> <pri/sec> <BAND> <From_freq> <To_freq> <file_name>"
    echo "ex : Read command:  ./test_radio_reg.sh R 0x1 1 100        ## read level status 100 times"
    echo "ex : Write command: ./test_radio_reg.sh W register_table   ## write the register_table"
    echo "ex : noise scanner: ./test_radio_reg.sh S pri FM 9970 10070 result.txt ## noise scanner from 99.7Mhz to 100.7MHz"
    echo "tool version"
    adb shell saf775x_util version
else
    type=$1
    
    if [ $type == 'R' ]; then
	reg=$2
	length=$3
	count=$4
        echo "read reg=$reg length=$length count=$count"
        while [ "$i" != "$count" ]
	do
		i=$(($i+1))
                echo "read count $i"
		adb shell saf775x_util read $reg $length
        done
    elif [ $type == 'W' ]; then
	file_name=$2
        #exec < $filename  ## for line in $ (cat file.txt) do echo "$ line" done 
        while read line
	do
		echo line=$line
		reg=`echo $line|awk '{print $1}'`
                if [ $reg != "##" ]; then
		    value=`echo $line|awk '{print $2}'`
                    echo "Set register $reg to $value"
                    adb shell saf775x_util write $reg $value 1
                fi
	done < $file_name
    elif [ $type == 'S' ]; then
#1) set  band(FM/AM/LW/SW) of primary radio or secondary radio
#2) set frequency to frequency_start
        if [ $2 = "pri" ]; then
           CHANNEL=0
        elif [ $2 = "sec" ]; then
           CHANNEL=1
        fi
        BAND=$3
        From_Freq=$4
        To_Freq=$(($5+1))
        TXT=$6
        echo "<<<Start noise scanner>>>>" > $TXT
        adb shell saf775x_util pset pri-radio-out pri-input
        if [ $BAND = "FM" ]; then
           echo "BAND FM From $From_Freq to $To_Freq" >> $TXT
           BAND=$((2#000))
        elif [ $BAND = "AM" ]; then
           echo "BAND AM From $From_Freq to $To_Freq" >> $TXT
           BAND=$((2#010))
        elif [ $BAND = "LW" ]; then
           echo "BAND LW From $From_Freq to $To_Freq" >> $TXT
           BAND=$((2#001))
        elif [ $BAND = "SW" ]; then
           echo "BAND SW From $From_Freq to $To_Freq" >> $TXT
           BAND=$((2#011))
        else
            echo "BAND slect error!!!"
            exit -1
        fi
      
        while [ "$From_Freq" -lt "$(($To_Freq))" ]
        do
            set_Freq_Mode $CHANNEL $From_Freq $BAND
            echo "tune to $From_Freq"
#3) read signal level
            REG_LEVEL=$(($(($CHANNEL_F*16#60))+1))
            REG_LEVEL=`adb shell saf775x_util read $REG_LEVEL 1`
            VAL_LEVEL=`echo $REG_LEVEL|awk '{print $2}'|cut -c 3-`
#4) write frequency and signal level(unit:dBv) to text file.
            VAL_LEVEL=$((16#${VAL_LEVEL//$'\r'}))
            #echo "VAL_LEVEL(num)=$VAL_LEVEL"
            DB_LEVEL=$(($(($VAL_LEVEL-16))/2))
            echo "Freq=$From_Freq REG_LEVEL=$REG_LEVEL Level=$DB_LEVEL=dB" >> $TXT
#5) frequency increase frequency_step
            From_Freq=$((From_Freq+1))
#6) repeat step 3 to step 5 until frequency from frequency_start to frequency_stop.
        done
    fi
fi
