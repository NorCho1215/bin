test ! -d /tmp/test/ && mkdir -p /tmp/test/
cd /tmp/test/
result="fail"
while [ $result == "fail" ]
do
  echo "PWD"
  repo init -u ssh://git-master:12001/tegra/manifest.git --manifest-branch=$1 --manifest-name=android.xml && result=success 
done
echo "check branch success"
