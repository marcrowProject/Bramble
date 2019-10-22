#!/bin/bash
clear
apd=$(ps -aux | grep "hostapd" | wc -l)
if [ $apd -gt 1 ]; then
	echo "The Bramble wifi access point is open."
	echo "Do you want to stop it? (y/n)"
	read ans
	if [ "$ans" = "y" ]; then
		echo "Stop the access point..."
		sudo ./tools/src/stopAccessPoint.sh
	fi
else
	echo "No wifi access point running."
	echo "Do you want to start one? (y/n)"
	read ans
	if [ "$ans" = "y" ]; then
		echo "Start the access point..."
		sudo ./tools/src/startAccessPoint.sh
		apd=$(ps -aux | grep "hostapd" | wc -l)
		if [ $apd -gt 1 ]; then
			clear
			echo "The access point is reachable (default name : Bramble)"
			echo "Do you want to display the password?(y/n)"
			read ans
			if [ "$ans" = "y" ]; then
				pass=$(sudo cat /etc/hostapd/hostapd.conf | grep "passphrase" | cut -d "=" -f2)
				echo $pass
			fi
		else
			echo "A problem occurred. Get more info with the following command 'journal -xe' or 'cat /var/log/syslog'"
			echo "If the problem persist open an issue on https://github.com/marcrowProject/Bramble/issues"
		fi
	else
		echo "ans = $ans"
	fi
fi

echo "Press a button to continue"
read ans
