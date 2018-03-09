#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"

ans="n"
folder="/media/pi/"
test=$(ls $folder)
#Select the directory where the usb is mounted
if [ $? != "0" ]; then
  #if user isn't logged as pi user
  alldir=$(ls /media/)
  clear
  for dir in $alldir
  do
    echo "Select where your usb is mounted : "
    echo $alldir
    echo
    echo -e $bReverse""$dir" (y/n)"$transparent
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

#Select the usb device
if [ $? = "0" ]; then
  clear
  for usb in $test
  do
    echo -e $title"Select the usb device : "$transparent
    echo $test
    echo
    echo $bReverse""$usb" (y/n)"$transparent
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
