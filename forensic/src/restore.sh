#!/bin/bash

bReverse="\e[7;1m"
transparent="\e[0m"
title="\e[3;33m"

red="\033[1;31m"
green="\033[1;32m"

clear

#-----------------------------Select a Disk--------------------------------------------
tabDisk=""
tabDisk=($(lsblk -f -o NAME,VENDOR,TYPE,SIZE | grep "disk" ))
size=0
#display all disks.
while true; do
	if [ -z "${tabDisk[size]}" ]; then #stop if we are in the end 
		break
	fi	
	echo "  "${tabDisk[size]}" "${tabDisk[size+1]}" "${tabDisk[size+2]}" "${tabDisk[size+3]}
	size=$[size+4]
done 
size=$[size/4]
i=$size 
ans=" "
#Select a disk
while true; do
	if [ $i -eq $size ]; then
		i=0
		#erase last -> and last reponse
		tput cup $[size-1] 0 
		echo "  "
	else
		#erase last ->
		tput cup $[i-1] 0 
		echo "  "
		tput cup $size 0 
		echo "  "
	fi
	tput cup $i 0
	echo -e $bReverse"->"$transparent
	tput cup $size 0
	read ans
	if [ $ans = "y" ]; then
		break
	fi
	i=$[i+1]
done
disk=${tabDisk[$[i*4]]}


#-----------------------------Select a partition on the disk--------------------------------------------
clear
tabPart=($(lsblk -f -o NAME,SIZE | grep "$disk[0-1]" |cut -d "s" -f 2))
#Display all partitions
j=0
while true; do
	if [ -z "${tabPart[j]}" ]; then #stop if we are in the end 
		break
	fi	
	echo "  s"${tabPart[j]}" "${tabPart[j+1]}
	j=$[j+2]
done 
#Select a partition
j=$[j/2]
if [ $j -eq 1 ];then # if we have only one partition we do not need to ask to user.
	partition="/dev/s${tabPart[$[0]]}"
else
	i=$j
	while true; do
		if [ $i -eq $j ]; then
			i=0
			#erase last -> and last reponse
			tput cup $[j-1] 0 
			echo "  "
		else
			#erase last ->
			tput cup $[i-1] 0 
			echo "  "
			tput cup $j 0 
			echo "  "
		fi
		tput cup $i 0
		echo -e $bReverse"->"$transparent
		tput cup $j 0
		read ans
		if [ $ans = "y" ]; then
			partition="/dev/s${tabPart[$[i*2]]}"
			break
		fi
		i=$[i+1]
	done
fi


#-----------------------------Select what you would like to extract--------------------------------------------
clear

echo "Pictures"
echo "Video"
echo "Word documents"
echo "ADOBE PDF"
echo "SOUND FILES"
echo "zip pptx docx"
echo "rar"

i=0
type=""
while [ $i -ne 7 ] ; do
	tput cup $i 15
	echo -e $title"(y/n)"$transparent
	tput cup $i 20
	read ans
	if [ $ans = "y" ]; then
		case $i in
			0)
				if [ -z $type ];then
					type="jpg,gif,png"
				else
					type=$type",jpg,gif,png"
				fi
				;;
			1)
				if [ -z $type ];then
					type="avi,mov"
				else
					type=$type",avi,mov"
				fi
				;;
			2)
				if [ -z $type ];then
					type="doc"
				else
					type=$type",doc"
				fi
				;;				
			3)
				if [ -z $type ];then
					type="pdf"
				else
					type=$type",pdf"
				fi
				;;
			4)
				if [ -z $type ];then
					type="wav"
				else
					type=$type",wav"
				fi
				;;
			5)
				if [ -z $type ];then
					type="zip"
				else
					type=$type",zip"
				fi
				;;
			6)
				if [ -z $type ];then
					type="rar"
				else
					type=$type",rar"
				fi
				;;
			*)
		esac
		tput cup $i 15
		echo -e $green" +   "$transparent
	else
		tput cup $i 15
		echo -e $red" -   "$transparent
	fi
	
	i=$[i+1]
	#in order avoid an empty restoration
	if [ -z $type ] && [ $i -eq 7 ]; then
		echo -e "Please select something."
		i=0
	fi
done



clear

#-----------------------------Start foremost--------------------------------------------
sudo rm rescue -r 2> /dev/null
echo "sudo foremost -t $type -i $partition -o rescue"
sudo sudo foremost -t $type -i $partition -o rescue
sudo chmod +rwx rescue
echo "it's done!"













