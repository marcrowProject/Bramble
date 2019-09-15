#!/bin/bash
websitePort=443
webconsolePort=4443
fileviewerPort=80

addr="192.168.1.77"

transparent="\e[0m"
title="\e[3;33m"
green="\033[1;32m"
warning="\033[1;31m"

ok="[$green OK $transparent]"
error="[$warning ERROR $transparent]"

echo $1
if [ $1 = "--start" ]; then
	echo -e "$title\tStart the web interface...$transparent"
    /var/www/bramble-dashboard/bramble/start.sh
    if [ $? -ne 0 ]; then
        echo -e "$error Unable to start the web service or the web console"
    fi
    status=$(nc -zv $addr $websitePort 2> /dev/null)
    if [ $? -eq 0 ]; then
        echo -e "$ok Web interface reachable"
    else
        echo -e "$error Web interface unreachable"
    fi

    status=$(nc -zv $addr $webconsolePort 2> /dev/null)
    if [ $? -eq 0 ]; then
        echo -e "$ok Web console reachable"
    else
        echo -e "$error Web console unreachable"
    fi

    status=$(nc -zv $addr $fileviewerPort 2> /dev/null)
    if [ $? -eq 0 ]; then
        echo -e "$ok Web file viewer reachable"
    else
        echo -e "$error Web file viewer unreachable"
    fi
fi

if [ $1 = "--stop" ]; then
    echo -e "$title\tStop the web interface$transparent"
    /var/www/bramble-dashboard/bramble/stop.sh
fi

echo "Press a button to quit"
read ans
