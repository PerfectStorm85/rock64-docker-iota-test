#!/bin/bash

getCurrentNeighbors(){

curNeighbors=$(cat ~/Iota/volumes/iri/iota.ini | grep "^NEIGHBORS = " | grep -oP "NEIGHBORS = \K.*")
IFS=' ' read -ra curNeighborsArray <<< "$curNeighbors"
counter=0
for element in "${curNeighborsArray[@]}"
do
        counter=$(($counter+1))
        if [ $counter -eq 1 ]
        then
                echo "Current Neighbors found: "
                echo
        fi
        echo "$counter. $element"
done
if [ $counter -eq 0 ]
then
        echo "No static neighbors found!"
fi
echo

}

addNeighbor(){

clear
echo
getCurrentNeighbors
echo "Please enter the neighbors TCP or UDP address."
echo "Make sure you both use TCP or UDP, a combination is not possible!"
echo "Example address: tcp://239.123.6.129:15600 or udp://iotanode.service:14600"
echo
echo "Leave empty to return to the previous menu"
echo
read -p "Address: " nb
if [ "$nb" == "" ]
then
	break
fi
echo
echo "Neighbor Added! $nb"
nbors="$curNeighbors $nb"
sed -i -e 's/^NEIGHBORS = .*$/NEIGHBORS = '"$nbors"'/g' ~/Iota/volumes/iri/iota.ini
echo
read -p "Press Enter to continue..." answer2

}

removeNeighbor(){

clear
if [ $counter -eq 0 ]
then
	echo "No neighbors found to remove!"
	echo
	read -p 'Press Enter to return to the previous menu' answer4
fi
echo
getCurrentNeighbors
echo "Which Neighbor do you want to remove? Type in the number and press enter to remove"
echo
read -p 'Number: ' removeNr
echo "To be implemented further!"

}

while [ true ]
do
clear
echo
getCurrentNeighbors
echo "What would you like to do?"
echo
echo "1. Add Neighbors"
echo "2. Remove Neighbors"
echo
echo "0. Return to main menu"
echo
read -p "Option: " answer
case $answer in
        0)
                exit;;
        1)
                addNeighbor;;
        2)
		removeNeighbor;;
	*)
		echo "Invalid Input!"
		read -p "Press Enter to continue..." answer2
		echo;;
esac
done
