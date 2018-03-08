#!/bin/bash
echo "to work this app need than you scan networks before"

echo "if you don't have scan networks around you, quit and do it"

com="n"
ans="n"
i=0
intSelected="none"
$networkC
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


./wifiJammer/src/monitor.sh $intSelected


target="none"
station=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 14 | grep -v "Station" | grep -v "ESSID" | sed "s/ /_/g")
channel=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 4 | grep -v "Station" | grep -v "ESSID")
bssid=$(cat result/scanNetwork/scan-01.csv | awk "/BSSID/,/Station/" | cut -d "," -f 1 | grep -v "Station" | grep -v "ESSID")

for essid in $station
do
	i=$[i+1]
	echo $essid" "$i
	read ans
	if [ $ans = "y" ]; then
		target=$essid
		break
	fi

done

if [ $target != "none" ]; then
	arrB=($bssid)
	arrC=($channel)
	B=${arrB[i]}
	C=${arrC[i]}
	T=$target

	#need to be in the same channel
	sudo iwconfig $intSelected channel $C
	sudo rm result/scanNetwork/user*
	#scna users
	airodump-ng $intSelected --bssid $B -c $C -w result/scanNetwork/user
fi


