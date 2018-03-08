#!/bin/bash
ans="n"
$networkC
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)
echo " choose the interface :"
while [ $ans != "y" ]
do
	for interface in $allInterface
		do
		echo $interface" (y/n)"
		read ans
		if [ $ans = "y" ]; then
			netMask=$(sudo ip a show $interface | grep "inet " | cut -d " " -f 6 | cut -d "/" -f 2)
			network=$(sudo route -n | grep $interface | cut -d " " -f 1 | grep -v "0.0.0.0")
			networkC=$network"/"$netMask
			echo "add : "$networkC
			if [ $network = "" ]; then
				echo "interface not initialized"
				exit
			fi
		fi
	done
done
rm ./result/scan.txt
sudo nmap -p 518 $networkC | grep "(" | grep -v "Host is up" | grep -v "Starting Nmap" >> ./result/scan.txt
echo "test"
echo "y to continue / n to quit"
cat ./result/scan.txt | while  read line ; do
  	echo $line
  	sleep 1
done
echo "Quit"
read ans


#ntalk
#nmap -p 518 192.168.1.0/24

#x11
#-p 6000 192.168.1.0/24

#basic scan
#nmap -sn 192.168.1.0/24
