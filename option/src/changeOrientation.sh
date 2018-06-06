#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

clear
echo -e $title"Press y to switch in right-hander mode"
echo -e "Press n to switch in left-hander mode"$transparent
read ans
clear
if [ $ans == "y" ]; then
	echo -e $warning"Your device will reboot"
	echo "please don't shutdown the device"
	echo "during the process (it may take few minutes)."
	echo -e "because it can damage your bramble"$transparent
	echo "press y if you have understood"
	read ans
	if [ $ans == "y" ]; then
		sed -i 's/k1=24/k1=18/g' conf/rpi-2.2TFT-kbrd.py
		sed -i 's/k3=18/k3=24/g' conf/rpi-2.2TFT-kbrd.py
		cd LCD-show
		./LCD32-show 180
	else
		clear
		echo -e $title"you stopped the process"
		echo -e "press a button to quit"$transparent
		read ans
	fi
else
	echo -e $warning"Your device will reboot"
	echo "please don't shutdown the device"
	echo "during the process (it may take few minutes)."
	echo -e "because it can damage your bramble"$transparent
	echo "press y if you have understood"
	read ans
	if [ $ans == "y" ]; then
		sed -i 's/k1=18/k1=24/g' conf/rpi-2.2TFT-kbrd.py
		sed -i 's/k3=24/k3=18/g' conf/rpi-2.2TFT-kbrd.py
		cd LCD-show
		./LCD32-show 0
	else
		clear
		echo -e $title"you stopped the process"
		echo -e "press a button to quit"$transparent
		read ans
	fi
fi
