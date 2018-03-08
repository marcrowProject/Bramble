#!/bin/bash



ans="n"
folder="/media/pi/"
test=$(ls $folder)
if [ $? != "0" ]; then
  #if user isn't logged as pi user
  alldir=$(ls /media/)
  clear
  for dir in $alldir
  do
    echo "Select where your usb is mounted : "
    echo $alldir
    echo
    echo $dir" (y/n)"
    read ans
    if [ $ans = "y" ]; then
      folder="/media/"$dir"/"
      echo $folder
      test=$(ls $folder)
      break
    fi
    clear
  done
fi

if [ $? = "0" ]; then
  clear
  for usb in $test
  do
    echo "Select the usb device : "
    echo $test
    echo
    echo $usb" (y/n)"
    read ans
    if [ $ans = "y" ]; then
      target=$folder$usb
      echo $target
      umount $target
      sudo eject $target
      break
    fi
    clear
  done
fi
read ans
