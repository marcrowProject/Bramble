#!/bin/bash

warning="\033[1;31m"
title="\e[3;33m"
transparent="\e[0m"
green="\033[1;32m"

lvl=$(cat "conf/lvl")
clear
if [ $lvl == "0" ]; then
  echo -e $green"Actual level menu : Classic"$transparent
  echo -e $title"If you want to use only easier to use features"
  echo -e "switch to the light menu."$transparent
  echo "To do that press y, else press another key"
  echo "to quit without changing."
  read ans
  if [ $ans == "y" ]; then
    echo 1 > conf/lvl
    clear
    echo -e $green"Done"$transparent
    echo -e $title"to apply the changes restart bramble"$transparent
    read ans
  fi
else
  echo -e $green"Actual level menu : Light"$transparent
  echo -e $title"If you want to use all features"
  echo -e "switch to the classic menu."$transparent
  echo "To do that press y, else press another key"
  echo "to quit without changing."
  read ans
  if [ $ans == "y" ]; then
    echo 0 > conf/lvl
    clear
    echo -e $green"Done"$transparent
    echo -e $title"to apply the changes restart bramble"$transparent
    read ans
  fi
fi
