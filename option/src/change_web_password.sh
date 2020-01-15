#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
green="\033[1;32m"
warning="\033[1;31m"

clear

ans="n"
pass=""
c_pass="a"
exit_code=-10
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
			while [ $exit_code -ne 0 ]
			do
				echo -e $title "Please enter the new password for "$name $transparent
				code=$(mysql -u root -D "bramble" -e "CALL get_code('$name', @code);SELECT @code;")
				code=$(echo $code | sed 's/[^ ]* *//')
				read -s pass
				echo -e $title "\nConfirm the password" $transparent
				read -s c_pass
				if [ "$pass" != "$c_pass" ]; then
					echo -e $warning "Password confirmation failed. The passwords entered are different"
				else
					pass=$(echo -n $pass | sha256sum | tr -d ' \n-')
					exit_code=$(mysql -u root -D "bramble" -e "CALL reset_password('$name','$code','$pass', @exit_code);SELECT @exit_code;")
					exit_code=$(echo $exit_code | sed 's/[^ ]* *//')
				fi
			done
			break
		fi
	done
done
echo -e "\nPress a button to quit"
read ans

