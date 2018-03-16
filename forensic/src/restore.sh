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
arg1="none"
if [ $# -ne 0 ]; then
	arg1=$1
fi

while [ $i -ne 7 ] && [ $arg1 != "all" ]; do
	tput cup $i 15
	echo -e $title"(y/n)"$transparent
	tput cup $i 20
	read ans
	if [ $ans = "y" ]; then
		case $i in
			0)
				if [ -z $type ];then
					type='-t jpg,gif,png'
				else
					type=$type',jpg,gif,png'
				fi
				;;
			1)
				if [ -z $type ];then
					type='-t avi,mov'
				else
					type=$type',avi,mov'
				fi
				;;
			2)
				if [ -z $type ];then
					type='-t doc'
				else
					type=$type',doc'
				fi
				;;				
			3)
				if [ -z $type ];then
					type='-t pdf'
				else
					type=$type',pdf'
				fi
				;;
			4)
				if [ -z $type ];then
					type='-t wav'
				else
					type=$type",wav"
				fi
				;;
			5)
				if [ -z $type ];then
					type='-t zip'
				else
					type=$type",zip"
				fi
				;;
			6)
				if [ -z $type ];then
					type='-t rar'
				else
					type=$type',rar'
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
	if [ $i -eq 7 ] && [ -z $type ]; then
		echo -e "Please select something."
		i=0
	fi
done
#-----------------------------Select where you save restored files--------------------------------------------
clear
echo "Do you want to save restored files in an usb disk or in the internal storage?"
echo -e $title"y to save in usb disk at /rescue_Date"
echo -e "n to save in your Bramble at Bramble/result/rescue/Date"$transparent
destination=""
d=$(date +%Y-%m-%d_%H-%M)
read ans
if [ $ans = "y" ]; then
	folder="/media/$USER/"
	test=$(ls $folder)
	#Select the directory where the usb is mounted
	if [ $? != "0" ]; then
	  #if the user change where all keys are mounted
	  alldir=$(ls /media/)
	  clear
	  for dir in $alldir
	  do
		echo "Select where your usb is mounted : "
		echo $alldir
		echo
		echo -e $bReverse""$dir" (y/n)"$transparent
		read ans
		if [ $ans = "y" ]; then
		  folder="/media/"$dir"/"
		  echo $folder
		  test=$(ls $folder)
		  break
		fi
		clear
	  done
	fi

	#Select the usb device
	if [ $? = "0" ]; then
	  clear
	  	#Until the user give a correct destination
		while [ -z $destination ] ; do
			for usb in $test
			do
				echo -e $title"Select the usb device : "$transparent
				echo $test
				echo
				echo -e $bReverse""$usb" (y/n)"$transparent
				read ans
				if [ $ans = "y" ]; then
					destination=$folder""$usb"/rescue/"$d
					break
				fi
				clear
			done
		done
	fi	
#internal storage
else
	clear
	echo -e $red"Be carefull this process can take a lot of memory!"
	echo "probably several GB." 
	echo "If you are not sure to have enougth place press stop-button"
	echo -e "And use an usb disk"$transparent
	echo "press y to continue"
	destination="result/rescue/$d"
	read ans
fi


clear

#-----------------------------Start foremost--------------------------------------------
echo $PWD
sudo rm rescue -r 2> /dev/null
echo "sudo foremost $type -i $partition -o $destination" 
echo -e $green "that can take a while, be patient :)"$transparent
sudo foremost $type -i $partition -o $destination
sudo chmod +rwx $destination
echo "it's done!"













