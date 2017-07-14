debug_script=1
i=0

function ddbug()
{
    test 1 -eq $debug_script && echo "nor_debug ${1}"
}

find . -type d -name .git > temp.log
ddbug "111"
exec < temp.log
ddbug "222"
while read line
do
    i=$(($i+1))
    ddbug "333=$i"
    ddbug "$line"
    temp=`echo $line |sed 's/.....$//'`
    ddbug "$temp"
    if [ "$temp" == "./.repo/repo" ] || [ "$temp" == "./.repo/manifests" ]; then
       echo "error"
    else
       rm $temp
       /usr/local/bin/repo sync $temp
    fi 
done
