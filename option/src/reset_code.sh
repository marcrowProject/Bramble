#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
green="\033[1;32m"

clear

ans="n"
allName=$(mysql -u root -D "bramble" -e "SELECT name FROM auth;" )
#delete the column name selected
allName=$(echo $allName | sed 's/[^ ]* *//')
while [ "$ans" != "y" ]
do
	for name in $allName
		do
		clear
		echo -e $title" choose an user :"$transparent
		echo "in : "$allName
		echo -e $bReverse""$name" (y/n)"$transparent
		read ans
		if [ "$ans" = "y" ]; then
			clear
			echo -e $title"\t    CODE \n"$transparent
			code=$(mysql -u root -D "bramble" -e "CALL get_code('$name', @code);SELECT @code;")
			code=$(echo $code | sed 's/[^ ]* *//')
			echo -e $green"\t"$code$transparent
			echo -e "\n\nEnter the above code in the 'frogot password' section of the web interface"
			break
		fi
	done
done
echo -e "\nPress a button to quit"
read ans

