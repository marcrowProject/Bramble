#!/bin/bash

dhcp_is_active=$(ps -aux | grep dhcp | wc -l)
if [ $dhcp_is_active -gt 1 ]; then
	sudo service isc-dhcp-server stop
	pid=$(cat /var/run/dhcpd.pid 2> /dev/null)
	if [ "$pid" != "" ]; then
		sudo kill $pid
		rm /var/run/dhcpd.pid
	fi
fi
echo "Configure network interface"
sudo ifdown wlan0
sudo ip addr add 192.168.0.1/24 dev wlan0
sudo ip link set dev wlan0 up
echo "Start the DHCP server"
sudo dhcpd wlan0
sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf &> /var/log/hostapd &
