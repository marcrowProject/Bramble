#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"
green="\033[1;32m"

ans="n"
intSelected="none"
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)

function restoreInterface {
        echo -e $title"Restore your internet connection"
        echo "Please wait"
       	sudo ifconfig $intSelected down
       	sudo iwconfig $intSelected mode managed
       	sudo ifconfig $intSelected up
       	sudo service network-manager restart
       	echo -e $green"Done."$transparent
}



while [ $ans != "y" ]
do
	for interface in $allInterface
	do
		echo -e $title" choose the interface :"$transparent
		echo $allInterface
		echo
		echo -e $bReverse""$interface" (y/n)"$transparent
		read ans
		echo $ans
		if [ $ans = "y" ]; then
			intSelected=$interface
			break
		fi
		clear
	done
done

if [ $intSelected = "none" ]; then
	echo -e $warning"please next time select an interface"$transparent
	exit
fi
rm -rf result/scanNetwork/scan
sudo ./wifiJammer/src/monitor.sh $intSelected
xterm -title "Search access point" -e sudo airodump-ng -a $intSelected -w result/scanNetwork/scan --ignore-negative-one
restoreInterface
