#!/bin/bash

ip=""
username=""
sshList=($(cat ../../conf/ssh))
echo $sshList
length=${#sshList}

#----------the user select the destination----------
while [ -z $ip ]
do
    i=0
    while [ $i -le $length ]
    do
	clear
	echo "Select the pc to establish a connection : "
        echo "username : ${sshList[$i]}"
        echo "-> at : ${sshList[$i+1]}"
        read ans
        if [ $ans = "y" ]; then
            username=${sshList[$i]}
            ip=${sshList[$i+1]}
            break
        fi
        i=`expr $i + 2 `
    done
done
#Save the destination information in the file conf/current_ssh
echo $username $ip > ../../conf/current_ssh
sudo /etc/init.d/ssh start
./create_ssh_tunnel.sh
