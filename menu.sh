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
		./config/ports.sh;;
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

printLogs(){

if [ "$2" = "" ]
then
	docker logs "iota_$1"
else
	docker logs -f "iota_$1"
fi
echo
read -p 'Press enter to continue' answer

}

readLogs() {

while [ true ]
do
clear
echo
echo "Which logs do you want to see?"
echo "Add f to the option to follow the logs."
echo "Example: 1f"
echo
echo "Use Ctrl+c to cancel following logs"
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
		printLogs "iri";;
	1f)
		printLogs "iri" "-f";;
	2)
		printLogs "nelson.cli";;
	2f)
		printLogs "nelson.cli" "-f";;
	3)
		printLogs "nelson.gui";;
	3f)
		printLogs "nelson.gui" "-f";;
	4)
		printLogs "field.cli";;
	4f)
		printLogs "field.cli" "-f";;
	*)
		echo "Unknown entree: $logsAnswer"
		read -p "Press enter to continue" answer2;;
esac
done
}

downloadDB(){

echo
echo "WARNING"
echo "This will remove the old database and download a fresh one."
echo
echo "Are you sure you want to continue?"
echo
read -p "y/n: " ddAnswer
if [ "$ddAnswer" = "y" ]
then
	echo
	echo "Stopping IRI..."
	echo
	~/stop.sh
	echo
	~/Iota/download_mainnet_db.sh
fi
}

updateNode(){

clear
echo
echo "This will (force) update all docker containers."
echo "Do you want to continue?"
echo
read -p 'y/n: ' updateAnswer
if [ "$updateAnswer" = "y" ]
then
	echo
	echo "Updating..."
	echo
	cd ~/Iota
	docker-compose stop
	docker-compose down
	rm ./updateScript*
	wget https://rock64iota.com/Iota/updateScript.sh
	chmod +x ./updateScript.sh
	./updateScript.sh $curVersion
	docker stop $(docker ps -a -q)
	# Delete all containers
	docker rm $(docker ps -a -q)
	# Delete all images
 	docker rmi $(docker images -q)
	docker container prune -f
	~/start.sh
	echo "$latestversion" | sudo tee ~/Iota/CurVersion.ini | grep -q ".*"
	echo
	echo "Update finished!"
	echo
	read -p "Press enter to continue" updAns
fi

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
		downloadDB
		read -p "Press enter to continue" answer2;;
	4)
		configNode;;
	5)
		readLogs;;
	6)
		updateNode;;
esac

}

while [ "True" ]
do
	curVersion=$(cat ~/Iota/CurVersion.ini)
	latestVersion=$(curl -s https://rock64Iota.com/Iota/IRIVersion.html)
	if [ "$curVersion" == "" ]
	then
		curVersion="Unknown"
	fi
	clear
	echo
	echo "Welcome to the Rock64 Main Menu. Version: $curVersion"
	echo "What would you like to do?"
	echo
	echo "0. (Re)Install Node"
	echo
	echo "1. (Re)Start Node"
	echo "2. Stop Node"
	echo "3. (Re)download Database"
	echo
	echo "Advanced settings:"
	echo "4. Change Node configurations"
	echo "5. View log files"
	echo
	echo "6. Update (Force) - Latest version: $latestVersion"
	echo
	echo "Q. Exit"
	echo
	read -p "Option: " answer
	readMenuOption $answer
done
