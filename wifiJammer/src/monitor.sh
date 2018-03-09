#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

if [ $# -eq 0 ]
  then
    echo -e $warning"Please select the interface"$transparent
    echo -e $title"example : ./monitor wlan0 "$transparent
    exit
fi
sudo ifconfig $1 down
sudo macchanger $1 -A
sudo iwconfig $1 mode monitor
sudo ifconfig $1 up
sudo iwconfig $1| grep Mode

#to be sure to don't have any conflict
pid=$(sudo airmon-ng check $1 | grep "^ [0-9]" | cut -d " " -f 2)
for process in $pid
do
	kill $process
done

pid=$(sudo airmon-ng check wlan0 | grep "[0-9]" | grep -v "Found" | cut -d " " -f 3 | grep "[0-9]")
for process in $pid
do
	kill $process
done
