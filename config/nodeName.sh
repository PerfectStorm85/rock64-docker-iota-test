#!/bin/bash

clear
curNodeName=$(cat ~/Iota/volumes/field.cli/config.ini | grep "name = " | grep -v "Hostname" | grep -oP "^name = \K.*")
echo
echo "Current node name: $curNodeName"
echo
echo "Do you want to change this?"
echo
read -p 'y/n: ' answer
if [ "$answer" != "y" ]
then
	clear
	exit
fi
echo
echo "Enter new node name"
echo "Leave empty to return to main menu"
echo
while [ true ]
do
	read -p 'Name: ' nodename
	if [ "$nodename" == "" ]
	then
		exit
	fi
	echo "$nodename - Is this correct?"
	read -p 'y/n: ' answerNodeName
	if [ "$answerNodeName" == "y" ]
	then
		sed -i -e 's/^name = .*$/name = '"$nodename"'/g' ~/Iota/volumes/field.cli/config.ini
		sed -i -e 's/^name = .*$/name = '"$nodename"'/g' ~/Iota/volumes/nelson.cli/config.ini
		echo
		echo "Node name changed to: $nodename"
		echo
		read -p "Press Enter to continue..." answer5
		break
	fi
done
