#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
green="\033[1;32m"

clear

ans="n"
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep -v "lo")

while [ $ans != "y" ]
do
	for interface in $allInterface
		do
		clear
		echo -e $title" choose the interface :"$transparent
		echo "in "$allInterface
		echo -e $bReverse""$interface" (y/n)"$transparent
		read ans
		if [ $ans = "y" ]; then
			clear
			sudo macchanger -s $interface
			echo -e $title"y to change for a random Mac adress"
			echo "n to quit"
			echo -e "press another key to enter by yourself the mac address"$transparent
			read ans
			clear
			if [ $ans != "n" ]; then
				sudo ip link set dev $interface down
				if [ $ans = "y" ]; then
					sudo macchanger -A $interface
				else
					echo $title"enter your new mac adress :"$transparent
					read ans
					sudo macchanger $interface -m $ans
				fi
				sudo ip link set dev $interface up
				echo "wait your interface restart..."
				sudo ./option/src/restartNetwork.sh $interface
				echo -e $green"It's done!"$transparent
				read ans
				exit
			else
				exit
			fi
		fi
	done
done
