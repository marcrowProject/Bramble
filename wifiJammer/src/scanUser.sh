#!/bin/bash
#optional argument : interface
#ex from Bramble directory : ./wifiJammer/src/scanUser.sh wlan1 
transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

clear

ans="n"
i=0
intSelected="none"
$networkC
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)

function restoreInterface {
        echo -e $title"Restore your internet connection"$transparent
        echo "Please wait..."
       	sudo ifconfig $intSelected down
       	sudo iwconfig $intSelected mode managed
       	sudo ifconfig $intSelected up
       	sudo service network-manager restart
       	echo -e $green"Done."$transparent
}

function ctrl_c() {
        restoreInterface
        exit
}

if [ $# -ne 0 ] ; then
	intSelected=$1
else
	while [ $ans != "y" ]
	do
		for interface in $allInterface
		do
			clear
			echo -e $title" choose the interface :"$transparent
			echo $allInterface
			echo
			echo -e $bReverse""$interface" (y/n)"$transparent
			read ans
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
fi

#Catch the ctrl_c event
trap ctrl_c INT

#--------------------------Scan Access Points around the device---------------------------
echo -e $title"Stop with Ctrl-c when you find your target."$transparent
rm -rf result/scanNetwork/scan-*
sudo ./wifiJammer/src/monitor.sh $intSelected
xterm -title "Search access point" -e sudo airodump-ng -a $intSelected -w result/scanNetwork/scan --ignore-negative-one
clear

target="none"
station=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 14 | grep -v "Station" | grep -v "ESSID" | sed "s/ /_/g")
channel=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 4 | grep -v "Station" | grep -v "ESSID")
bssid=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 1 | grep -v "Station" | grep -v "ESSID")
nbStation=-2
for nb in $bssid
do
	nbStation=$[nbStation+1]
done

while [ $target = "none" ]
do
	i=0
	for essid in $station
	do
		i=$[i+1]
		if [ $essid != "" ]; then
			echo -e $title"Please select an access point"$transparent
			echo -e $green"We found $nbStation access points"$transparent
			echo -e $bReverse""$essid" "$i""$transparent
			read ans
			if [ $ans = "y" ]; then
				target=$essid
				break
			fi
			clear
		fi
	done
done

arrB=($bssid)
arrC=($channel)
B=${arrB[i]}
C=${arrC[i]}
T=$target

#need to be in the same channel
sudo iwconfig $intSelected channel $C
sudo rm result/scanNetwork/user-*
#scan users
xterm -title "Scan all user connect on the $target network" -e sudo airodump-ng $intSelected --bssid $B -c $C -w result/scanNetwork/user

