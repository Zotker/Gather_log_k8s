#!/bin/bash

TAIL=300
DATE=$(date +%d.%m.%y)




if [ -d ./"$DATE" ]; then
	echo Directory for logs already exist
else
	echo Creating directory "$DATE" for logs
	mkdir ./"$DATE"
fi

cd ./"$DATE"

s1=$(kubectl get pod -A | sed -e 's/\s\+/,/g' | cut -d ',' -f 1)
arry1=($s1)
s2=$(kubectl get pod -A | sed -e 's/\s\+/,/g' | cut -d ',' -f 2)
arry2=($s2)

COUNT=$((${#arry1[@]} - 1))

echo Gathering logs from "$COUNT" pods, last "$TAIL" strings:

for ((i=1; i <= "$COUNT"; i++))
do
	echo "$i" log
	kubectl logs -n ${arry1[$i]} --tail="$TAIL" ${arry2[$i]} | grep -e WARN -e ERROR >  ${arry1[$i]}---${arry2[$i]}.log
done

find . -size 0 -delete

echo Gathering complete