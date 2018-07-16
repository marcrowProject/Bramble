#/bin/bash

#-----source : https://www.tunnelsup.com/raspberry-pi-phoning-home-using-a-reverse-remote-ssh-tunnel/ ---

username=""
ip=""

createTunnel() {
    /usr/bin/ssh -N -R 2222:localhost:22  -i ~/.ssh/$username $username@$ip
    if [[ $? -eq 0 ]]; then
    	echo Tunnel to jumpbox created successfully
    else
    	echo $?
    	sleep 3
    	createTunnel
    fi
}

info=($(cat ../../conf/current_ssh))
username=${info[0]}
ip==${info[1]}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
    echo Creating new tunnel connection
    createTunnel
fi
