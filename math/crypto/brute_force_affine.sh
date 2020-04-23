#!/bin/bash

declare -a arr=("1" "3" "5" "7" "9" "11" "15" "17" "19" "21" "23" "25")

for ALPHA in "${arr[@]}"
do
	for BETA in `seq 0 25`
	do
		clear
		printf "ALPHA: ${ALPHA}\t\tBETA: ${BETA}\n\n\n\n"
		./de_affine.py code.txt ${ALPHA} ${BETA}
		read -sn1 POOPNUGGET
		#sleep 2
	done
done
