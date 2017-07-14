OS=$1
link=$2
if [ "$#" -lt 1 ]; then
    echo "command: /home/ncho/bin/get_GVS_3OS.sh <OS:a/q/l/f> <link: output.tgz>"
else

  if [ $OS == "a" ]; then
    test -d android && rm android -rf
    mkdir android
    cd android
  elif [ $OS == "f" ]; then
    test -d foundation && rm foundation -rf
    mkdir foundation
    cd foundation
  elif [ $OS == "q" ]; then
    test -d qnx && rm qnx -rf
    mkdir qnx
    cd qnx
  elif [ $OS == "l" ]; then
    test -d linux && rm linux -rf
    mkdir linux
    cd linux
  else
    echo "Wrong OS"
  fi
  axel -n 40 $link
fi
