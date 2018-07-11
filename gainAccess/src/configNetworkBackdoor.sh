#!/bin/bash

clear
echo -e "\tConfiguration"
echo "You need to use a keyboard for this."
echo "Please enter the ip adress of your pc : "
echo -e "help : on your pc's web browser \ngo to http://ipaddressworld.com/"
echo "your ip adress will be displayed"
read ip

clear
echo "Please enter the user's name of your pc"
read username

clear
echo "Please enter the password"
read password

echo "$username $ip">>../../conf/ssh

clear
ssh-keygen -N "" -f ~/.ssh/$username
chmod 600 ~/.ssh/$username.pub

clear
if [[ $? -eq 0 ]]; then
    echo "A rsa-key has been created"
    echo "to protect you."
else
    echo "Error we can't generate a rsa-key"
    echo "to secure the connection"
    exit
fi
clear
ssh-copy-id -i ~/.ssh/$username.pub $username:$password@$ip
if [[ $? -eq 0 ]]; then
    echo "Your key has been share with your pc"
    echo "Your ssh connection is secured"
else
    echo "Error we can't share your rsa-key"
    echo "to secure the connection"
    exit
fi
read ans
