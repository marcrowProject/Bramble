#!/bin/bash

ans="n"
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep -v "lo")
echo " choose the interface :"
while [ $ans != "y" ]
do
	for interface in $allInterface
		do
		echo $interface" (y/n)"
		read ans
		if [ $ans = "y" ]; then
			sudo macchanger -s $interface
			echo "y to change for a random Mac adress"
			echo "n to quit"
			echo "press another key to enter by yourself the mac address"
			read ans
			if [ $ans != "n" ]; then
				sudo ip link set dev $interface down
				if [ $ans = "y" ]; then
					sudo macchanger -A $interface	
				else
					echo "enter your new mac adress :"
					read ans
					sudo macchanger $interface -m $ans			
				fi
				sudo ip link set dev $interface up
				echo "wait your interface restart..."
				sudo ./option/src/restartNetwork.sh $interface
				echo "It's done!"
				read ans	
				exit
			else
				exit			
			fi
		fi
	done
done
