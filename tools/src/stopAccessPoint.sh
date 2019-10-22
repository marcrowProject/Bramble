#!/bin/bash
echo "Stop the access point..."
killall hostapd
sudo service isc-dhcp-server stop
pid=$(cat /var/run/dhcpd.pid 2> /dev/null)
if [ "$pid" != "" ]; then
	echo "Stop the DHCP server"
	sudo kill $pid
	sudo rm /var/run/dhcpd.pid
fi
echo "suppress old ip address"
sudo ip addr del 192.168.0.1/24 dev wlan0
echo "The access point is stopped"
