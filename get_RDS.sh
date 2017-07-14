if [ "$#" -lt 2 ]; then
    echo "command: get_RDS.sh <time> <folder> <count>"
    exit 0
fi

k=1
count=$2
folder=$1
mkdir $folder
cd $folder
while [ "$k" != "$count" ]
do
    #ate=`date |awk '{print $4}'`
    adb pull /data/local/tmp/rds.data 
    mv rds.data rds_${k}.data
    sleep $1
    k=$(($k+1))
done
cd ..

