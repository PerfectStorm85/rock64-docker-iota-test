 #!/bin/bash
configNode() {

while [ true ]
do

clear
echo
echo "What would you like to cofigure?"
echo
echo "1. Node Name"
echo "2. Network Settings"
echo "3. Ports"
echo "4. Donation address"
echo "5. Automatic updates"
echo "6. Static Neighbors"
echo
echo "0. Return to main menu"
echo
read -p "Option: " configAnswer
case $configAnswer in
	0)
		break;;
	1)
		./config/nodeName.sh;;
	2)
		./config/networkSettings.sh;;
	3)
		./config/ports.sh
		read -p "Press enter to continue" answer2;;
	4)
		./config/donationAddress.sh
		read -p "Press enter to continue" answer2;;
	5)
		./config/automaticUpdates.sh
		read -p "Press enter to continue" answer2;;
	6)
		./config/staticNeighbors.sh;;
	*)
		echo "Invalid Input..."
		read -p "Press enter to continue" answer2;;
esac

done

}

readLogs() {

while [ true ]
do
clear
echo
echo "Which logs do you want to see?"
echo
echo "1. IRI"
echo "2. Nelson Cli"
echo "3. Nelson Gui"
echo "4. CarrIOTA Field"
echo
echo "0. Return to main menu"
echo
read -p "Option: " logsAnswer

case $logsAnswer in
	0)
		clear
		break;;
	1)
		docker logs iota_iri
		read -p "Press enter to continue" answer2;;
	2)
		docker logs iota_nelson.cli
		read -p "Press enter to continue" answer2;;
	3)
		docker logs iota_nelson.gui
		read -p "Press enter to continue" answer2;;
	4)
		docker logs iota_field.cli
		read -p "Press enter to continue" answer2;;
	*)
		echo "Unknown entree: $logsAnswer"
		read -p "Press enter to continue" answer2;;
esac
done
}

readMenuOption() {
	case $1 in
	Q)
		echo
		echo "Exit...!"
		echo
		exit;;
	q)
		echo
		echo "Exit...!"
		echo
		exit;;
	0)
		~/install.sh
		read -p "Press enter to continue" answer2;;
        1)
		clear
		~/start.sh
		read -p "Press enter to continue" answer2;;
	2)
		clear
		~/stop.sh
		read -p "Press enter to continue" answer2;;
	3)
		clear
		~/Iota/download_mainnet_db.sh;;
	4)
		configNode;;
	5)
		readLogs
esac

}

while [ "True" ]
do
	clear
	echo
	echo "Welcome to the Rock64 Main Menu."
	echo "What would you like to do?"
	echo
	echo "0. (Re)Install Node"
	echo
	echo "1. Start Node"
	echo "2. Stop Node"
	echo "3. (Re)download Database"
	echo
	echo "Advanced settings:"
	echo "4. Change Node configurations"
	echo "5. View log files"
	echo
	echo "Q. Exit"
	echo
	read -p "Option: " answer
	readMenuOption $answer
done
