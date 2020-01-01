#!/bin/bash
websitePort=443
webconsolePort=4443

addr_list=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
transparent="\e[0m"
title="\e[3;33m"
green="\033[1;32m"
warning="\033[1;31m"

ok="[$green OK $transparent]"
error="[$warning ERROR $transparent]"

echo $1
if [ $1 = "--start" ]; then
	echo -e "$title\tStart the web interface...$transparent"
    /var/www/bramble-dashboard/start.sh
    if [ $? -ne 0 ]; then
	echo $?
        echo -e "$error Unable to start the web service or the web console"
    fi
    for addr in $addr_list; do
		status=$(nc -zv $addr $websitePort 2> /dev/null)
		if [ $? -eq 0 ]; then
		    echo -e "$ok Web interface reachable at $addr"
		else
		    echo -e "$error Web interface unreachable at $addr"
		fi
	done
    

fi

if [ $1 = "--stop" ]; then
    echo -e "$title\tStop the web interface$transparent"
    /var/www/bramble-dashboard/stop.sh
fi

echo "Press a button to quit"
read ans
