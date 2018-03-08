#!/bin/bash
intSelected="none"
if [ $# -eq 1 ]
  then
    intSelected=$1
else
	ans="n"
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
				echo "ok"
				break
			fi
			clear
		done
	done
fi

if [ $intSelected = "none" ]; then
	echo "please next time select an interface"
	exit
fi
echo "here"
sudo ifconfig $intSelected down
sudo iwconfig $intSelected power off
sudo iwconfig $intSelected mode managed
sudo ifconfig $intSelected up
sudo service  wpa_supplicant restart
sudo service  avahi-daemon restart
sudo service dhcpcd restart
sudo service networking restart

