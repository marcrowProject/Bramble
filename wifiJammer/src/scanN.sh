#!/bin/bash

ans="n"
intSelected="none"
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)
while [ $ans != "y" ]
do
	for interface in $allInterface
	do
		echo " choose the interface :"
		echo $allInterface
		echo
		echo $interface" (y/n)"
		read ans
		if [ $ans = "y" ]; then
			intSelected=$interface
		fi
		clear
	done
done

if [ $intSelected = "none" ]; then
	echo "please next time select an interface"
	exit
fi

rm result/scanNetwork/scan*
sudo ./wifiJammer/src/monitor.sh $intSelected
sudo airodump-ng $intSelected -w result/scanNetwork/scan
