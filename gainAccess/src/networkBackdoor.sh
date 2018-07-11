#!/bin/bash

ip=""
username=""
echo "Select the pc to establish a connection : "
sshList=($(cat ../../conf/ssh))
echo $sshList
length=${#sshList}
while [ -z $ip ]
do
    i=0
    while [ $i -le $length ]
    do
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
echo $username $ip > ../../conf/current_ssh
sudo /etc/init.d/ssh start
while [ true ]
do
        ./create_ssh_tunnel.sh
        sleep 5s
done
