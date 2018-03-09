#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

allInterface=$(sudo airmon-ng | grep "wlan" | cut --output-delimiter "iw" -f 2)
echo -e $title"choose the interface :"$transparent

if [ $allInterface = " " ]; then
	echo -e $warning"You don't have interface compatible"$transparent
	exit
fi
ans="n"
while [ $ans != "y" ]
do
	for interface in $allInterface
		do
		echo -e $bReverse""$interface" (y/n)"$transparent
		read ans
		if [ $ans = "y" ]; then
			try=$(sudo airmon-ng start $interface | grep "^ [0-9]" | cut -d " " -f 2)
			for process in $try
			do
				echo -e $warning"wait...some process will be killed"$transparent
				sudo kill $process
				sudo airmon-ng start $interface | grep "^ [0-9]" | cut -d " " -f 2
			done
			sudo rm ./tools/src/orld*
			sudo airodump-ng wlan0mon -world

			rm ./result/resume.txt
			cat ./tools/src/orld-01.csv | cut -d ',' -f 1,4,6,14 >> ./result/resume.txt
			cat ./result/resume.txt | while  read line ; do
			  	echo $line
			  	sleep 1
			done
		fi
	done
done
