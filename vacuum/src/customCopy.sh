#!/bin/bash
#-------------------------------------Color------------------------------------------

bReverse="\e[7;1m"
transparent="\e[0m"
title="\e[3;33m"
red="\033[1;31m"
green="\033[1;32m"


#----------------------------Select a source for the copy------------------------------
clear
folder="/media/$USER/"
test=$(ls $folder)
usbSrc=""
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
	while [ -z $source ] ; do
		for usb in $test
		do
			echo -e $title"Select a target usb device : "$transparent
			echo $test
			echo
			echo -e $bReverse""$usb" (y/n)"$transparent
			read ans
			if [ $ans = "y" ]; then
				source=$folder""$usb
				usbSrc=$usb
				break
			fi
			clear
		done
	done
fi


#----------------------------Select a destination for the copy----------------------------

clear
echo "Do you want to copy files in an usb disk or in the internal storage?"
echo -e $title"y to save in usb disk at /clone"
echo -e "n to save in your Bramble at Bramble/result/clone"$transparent
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
				echo -e $test"\n"
				echo -e $bReverse""$usb" (y/n)"$transparent
				read ans
				if [ $ans = "y" ]; then
					destination=$folder""$usb"/clone"
					mkdir $destination 2> /dev/null
					destination=$folder""$usb"/clone/"$usbSrc"_"$d
					mkdir $destination 2> /dev/null
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
	echo "If you are not sure to have enougth place press stop-button"
	echo -e "And use an usb disk"$transparent
	echo "press y to continue"
	destination="clone/$usbSrc""_$d"
	read ans
fi

#-------------------------------Select types of files----------------------------
clear

echo "Pictures"
echo "Video"
echo "Suite Office"
echo "PDF txt"
echo "Sound files"
echo "7zip zip gz bz rar"
i=0
size=0
type=""
#user selects what he wants
while [ $i -ne 6 ]; do
	tput cup $i 15
	echo -e $title"(y/n)"$transparent
	tput cup $i 20
	read ans
	if [ $ans = "y" ]; then
		case $i in
			0)
				type=$type"*.img *.png *jpg *.jpeg *.gif *.bmp "
				size=$size+6
				;;
			1)
				type=$type"*.mp4 *.divx *.mov *.avi "
				size=$size+4
				;;
			2)
				type=$type"*.docx *.doc *.ppt *.pptx *.xls *.xml *.xlsm *.xlsx "
				size=$size+8
				;;				
			3)
				type=$type"*.pdf *.txt "
				size=$size+2
				;;
			4)
				type=$type"*.mp3 *.mp4 *.wav *.raw "
				size=$size+4
				;;
			5)
				type=$type"*.7z *.zip *.bz *.gz *.rar *.xz "
				size=$size+6
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
	if [ $i -eq 6 ] && [ -z $type ]; then
		echo -e "Please select something."
		i=0
	fi
done

#------------------------------- Copy process --------------------------------
	

#                              space escape        quote escape
resultSrc=$(echo $source | sed -e "s/ /\\\ /g" | sed "s/'/\\\'/g")
resultDst=$(echo $destination | sed -e "s/ /\\\ /g" | sed "s/'/\\\'/g")
echo "source "$resultSrc
echo "destination "$resultDst

clear
#echo "type "$type
tput cup 3 0
echo "["
tput cup 3 $[size+1]
echo "]"
i=0
for format in $type
do			#find all files with the specific format and escape spaces in the path
	find $resultSrc -iname $format | while read file; do
		cp "$file" $resultDst 2> /tmp/copyProblem.txt
		tput cup 1 0
		echo "copy in progress Ooo"
		tput cup 1 0
		echo "copy in progress oOo"
		tput cup 1 0
		echo "copy in progress ooO"
		tput cup 4 0
	done
	i=$[i+1]
	tput cup 3 $i
	echo "-"
done

clear
echo -e $red
cat tmp/copyProblem.txt 2> /dev/null
echo -e $transparent
tput cup 1 9
echo -e $green"Done \n"$transparent
echo "    press a button"
read ans






