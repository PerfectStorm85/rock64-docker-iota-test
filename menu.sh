 #!/bin/bash

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
		echo "Exit...!"
		exit;;
	1)
		~/install.sh;;
        2)
		clear
		~/start.sh;;
	3)
		clear
		~/stop.sh;;
	4)
		clear
		~/Iota/download_mainnet_db.sh;;
	5)
		echo "Change Configs";;
	6)
		readLogs;;
esac
	read -p "Press enter to continue" answer2
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
