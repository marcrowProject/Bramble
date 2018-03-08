#!/bin/bash

allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1)

for interface in $allInterface
do
	echo $interface" : "
	i=0
	inet=$(sudo ip a show $interface | grep "inet" | cut -d " " -f 6)
	for ip in $inet
	do
		if [ $i -eq 0 ]; then
			echo "  IPv4 : "$ip
		fi
		if [ $i -eq 1 ]; then
			echo "  IPv6 : "$ip
		fi
		i=1
	done
done

echo "Quit :"
read ans 



