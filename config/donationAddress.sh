#!/bin/bash

clear
curDonationAddress=$(cat ~/Iota/volumes/field.cli/config.ini | grep "address = " | grep -oP "^address = \K.*")
echo
echo "Current donation address: $curDonationAddress"
echo
echo "Do you want to change this?"
echo
read -p 'y/n: ' answer
if [ "$answer" != "y" ]
then
	exit
fi
echo
echo "Enter new donation address"
echo "Leave empty to cancel and return to main menu"
echo
while [ true ]
do
	read -p 'Name: ' donationAddress
	if [ "$donationAddress" == "" ]
	then
		exit
	fi
	echo "$donationAddress - Is this correct?"
	read -p 'y/n: ' answerDonationAddress
	if [ "$answerDonationAddress" == "y" ]
	then
		sed -i -e 's/^address = .*$/address = '$donationAddress'/g' ~/Iota/volumes/field.cli/config.ini
		break
	fi
done
