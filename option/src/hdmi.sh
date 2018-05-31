#!/bin/bash

echo "Press y to use only the hdmi"
echo "Press n to use only the built-in screen"
echo "Press stop to quit"
read ans
clear
if [ $ans == "y" ]; then 
	echo "Be carefull the built-in screen will be disabled"
	echo "So if you are not plugged in hdmi you will not be"
	echo "able to use bramble."
	echo "Press y if you are plugged in hdmi"
	echo "Else press n without issue"
	read ans
	if [ $ans == "y" ]; then
		cd LCD-show
		./LCD-hdmi
	fi
else
	./option/src/changeOrientation.sh
fi