#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

path=""
ans=""
echo -e $title"select the file/folder you want to erase : "$transparent
echo "-y- from internal storage "
echo "-n- from usb device"
read ans
if [ $ans = "y" ]; then
  path='/home/scarecrow/Bureau/bramble/result'
  echo $path
else
  path='/media/pi'
fi

clear

while true;do
  all=$(ls -a $path)
  for choice in $all
  do
    echo "current -- $path --"
    echo $all
    echo
    echo -e $bReverse$choice" (y/n)"$transparent
    read ans
    if [ $ans = "y" ]; then
      path=$path"/"$choice
      break
    fi
    clear
  done

  clear

  if [ -d $path ]; then
    echo $path
    echo "-y- to select the directory"
    echo "-n- to continue in"
    read ans
    if [ $ans = "y" ]; then
      break
    fi
  else
    break
  fi
  clear
done

clear

echo $path
echo -e $warning"after that your datas from $path was deleting for ever!"
echo -e "No one will can get back your datas "$transparent
echo -e $title"do you want to remove : $path ? (y/n)"$transparent
read ans
if [ $ans = "y" ]; then
  clear
  sudo srm -r -l $path
else
  echo -e $title"erasing cancelled"$transparent
fi
