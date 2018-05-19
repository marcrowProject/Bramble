#!/bin/bash

title="\e[3;33m"
green="\033[1;32m"
transparent="\e[0m"

clear

git pull --progress
echo -e $title"If an error occured press CTRL-C to quit."
echo "Solve it and come back after."
echo -e "Else press y or n to finalise the update."$transparent
read ans
sudo chown $USER ./ -R
make
clear
echo -e $green "your system has been updated" $transparent

