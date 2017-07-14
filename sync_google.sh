

for ((i=0; i<=$1; i=i+1))
do
   echo "Nor Debug $i"
   repo sync -j4 -q -c --no-tags
done
