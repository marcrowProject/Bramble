#!/bin/bash
# $1 is the target
# $2 is the dictionary
# $3 option for the username
# $4 is the username
# $5 type of attack
# $6 = $begin (optionnal)
red="\033[1;31m"
green="\033[1;32m"
transparent="\e[0m"

lines=$(wc -l $2 | cut -d " " -f 1)
echo $lines
if [ -z $6 ]; then
	begin=0
else
	begin=$6
	echo "oui"
	red tmp
fi
path=$(dirname $2)
n=$(($lines/90))
n=$((n+1))
for i in `seq $begin $n`;
	do
	./tools/src/cutter.sh $2 $i $(($i+1)) $path/tmp_dico
	echo "hydra -vV $3 $4 -P $path/tmp_dico$i -e s -F -o result/scanNetwork/tmp $1 " $5" "
	hydra -vV $3 $4 -P $path/tmp_dico$i -e s -F -o result/scanNetwork/tmp $1 $5 
	rm $path/tmp_dico$i
	#if hydra found a password
	state=($(tail -n 1 result/scanNetwork/tmp))

	if [ ! -e "./hydra.restore" ]; then
		echo " "
	else
		clear
		echo -e $red"BruteFore Stopped"$transparent
		#save the name of the dictionnary, tmp_dico number , and type. 
		echo $1 $2 $3 $4 $i> ".restoreBruteForce$5"
		rm ./hydra.restore 
		#if we restore, we will restart from the beginning of the dictionary
		#it's not a big deal because it's maximum 89 test we need to do
		#the advantage is that we can have a restore file for different types of brute force.
		exit 2
	fi 
	if [ ${state[0]} = "#" ]; then
		echo -e $red"We have finished to test $((($i+1)*90)) passwords"
		echo -e "\t\t but"
		echo -e "We actually didn't find a correct password"$transparent
	else
		echo $state
		echo "It's done :"
		rm $path/tmp_dico*
		break
	fi

done
