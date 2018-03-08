#!/bin/bash
i=-1
target="none"
bssid=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm1 "(?<=<BSSID>)[^<]+")
name=$(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<client-manuf>)[^<]+" | sed "s/ /_/g")


for select in $name
do
	i=$[i+1]
	echo $select
	read ans
	if [ $ans = "y" ]; then
		target=$select
		break
	fi

done

if [ $target != "none" ]; then
	tabM=($(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<client-mac>)[^<]+"))
	echo ${tabM[0]}"val1"
	echo ${tabM[1]}"val2"
	echo "--------------------"
	
	tabC=($(cat result/scanNetwork/user-01.kismet.netxml | grep -oPm100 "(?<=<channel>)[^<]+" ))

	echo "*********************"
	
	echo "BBSID : "$bssid
	echo "Mac : "${tabM[i]}
	echo "Channel : "${tabC[$[i+1]]}



fi

