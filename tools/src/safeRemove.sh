#!/bin/bash
path=""
ans=""
echo "select the file/folder you want to erase : "
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
    echo $choice" (y/n)"
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
echo "after that your datas from $path was deleting for ever!"
echo "No one will can get back your datas "
echo "do you want to remove : $path ? (y/n)"
read ans
if [ $ans = "y" ]; then
  clear
  sudo srm -r -l $path
else
  echo "erasing cancelled"
fi
