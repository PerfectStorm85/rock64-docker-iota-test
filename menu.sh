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
		./config/nodeName.sh
		read -p "Press enter to continue" answer2;;
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

clear
echo
echo "Which logs do you want to see?"
echo
echo "1. IRI"
echo "2. Nelson Cli"
echo "3. Nelson Gui"
echo "4. CarrIOTA Field"
echo
read -p "Option: " logsAnswer

case $logsAnswer in
	1)
		docker logs iota_iri;;
	2)
		docker logs iota_nelson.cli;;
	3)
		docker logs iota_nelson.gui;;
	4)
		docker logs iota_field.cli;;
	*)
		echo "Unknown entree: $logsAnswer"
esac
}

readMenuOption() {
	case $1 in
	0)
		echo
		echo "Exit...!"
		echo
		exit;;
	1)
		~/install.sh
		read -p "Press enter to continue" answer2;;
        2)
		clear
		~/start.sh
		read -p "Press enter to continue" answer2;;
	3)
		clear
		~/stop.sh
		read -p "Press enter to continue" answer2;;
	4)
		clear
		~/Iota/download_mainnet_db.sh;;
	5)
		configNode;;
	6)
		readLogs
		read -p "Press enter to continue" answer2;;
esac

}

while [ "True" ]
do
	clear
	echo
	echo "Welcome to the Rock64 Main Menu."
	echo "What would you like to do?"
	echo
	echo "1. (Re)Install Node"
	echo
	echo "2. Start Node"
	echo "3. Stop Node"
	echo "4. (Re)download Database"
	echo
	echo "Advanced settings:"
	echo "5. Change Node configurations"
	echo "6. View log files"
	echo
	echo "0. Exit"
	echo
	read -p "Option: " answer
	readMenuOption $answer
done
