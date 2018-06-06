#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"
green="\033[1;32m"

clear
echo -e $title"Press y to use only the hdmi"
echo "Press n to use only the built-in screen"
echo -e "Press stop to quit"$transparent
read ans
clear
if [ $ans == "y" ]; then
	echo -e $warning"Be carefull the built-in screen will be disabled"
	echo "So if you are not plugged in hdmi you will not be"
	echo "able to use bramble."
	echo "Press y if you are plugged in hdmi"
	echo -e "Else press n without issue"$transparent
	read ans
	if [ $ans == "y" ]; then
		clear
		echo -e $warning"Your device will reboot"
		echo "please don't shutdown the device"
		echo "during the process (it may take few minutes)."
		echo -e "because it can damage your bramble"$transparent
		echo "press y if you have understood"
		read ans
		if [ $ans == "y" ]; then
			cd LCD-show
			./LCD-hdmi
		else
			clear
			echo -e $title"you stopped the process"
			echo -e "press a button to quit"$transparent
			read ans
		fi
	fi
else
	./option/src/changeOrientation.sh
fi
