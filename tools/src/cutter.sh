#!/bin/bash

if [ $1 == "-h" ] || [ $1 == "--help" ]; then
	echo "This script allow to cut file"
	echo "exemple : ./cutter.sh dico.txt 0 5 cutter"
	echo "create 5 files : cutter0 cutter1 cutter2.."
	echo "each files contain 90 lines"
	echo "cutter0 contains lines 1 to 90 of dico.txt"
	exit
fi


for j in `seq $2 $3`
do 
	sed -n -e "$(($j*90+1)),$((($j+1)*90))p" $1 > $4$j 
done
