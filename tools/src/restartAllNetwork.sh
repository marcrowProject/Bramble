#!/bin/bash
monInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep "mon")

#supress mon interfaces
for mon in $monInterface
do
	sudo iw dev $mon del
done

allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep -v "eth" | grep -v "lo")

#set interface in managed mode
for interface in $allInterface
do
	sudo ifconfig $interface down
	sudo iwconfig $interface power off
	sudo iwconfig $interface mode managed
	sudo ifconfig $interface up
	
	
done

#restart all service 
sudo service  wpa_supplicant restart
sudo service  avahi-daemon restart
sudo service dhcpcd restart
sudo service networking restart


