#!/bin/bash

warning="\033[1;31m"
title="\e[3;33m"
transparent="\e[0m"
green="\033[1;32m"

clear

ans=" "
status=$(sudo /etc/init.d/ssh status | grep "Active" | cut -d " " -f 5)
if [ $status == "active" ]; then
  echo -e $title"ssh status :"$transparent$green $status"\n"$transparent
  echo "press y to turn off ssh"
  echo "press n to exit without making any changes"
  read ans
  if [ $ans == "y" ]; then
    sudo /etc/init.d/ssh stop
    echo -e $green"\n\t\tdone"$transparent
    read ans
  fi
else
  echo -e $title"ssh status :"$transparent$warning $status"\n"$transparent
  echo "press y to turn on ssh"
  echo "press n to exit without making any changes"
  read ans
  if [ $ans == "y" ]; then
    sudo /etc/init.d/ssh start
    echo -e $green"\n\t\tdone"$transparent
    read ans
  fi
fi
