#!/bin/bash
cd Iota
clear
echo

echo "Welcome to the re-installation process of the Full IRI node for Rock64"
echo
echo "WARNING! IRI NODE WILL BE COMPLETELY REMOVED AND REINSTALLED."
echo "Are you sure you want to continue?"
read -p 'y/n: ' answer
if [ "$answer" == "y" ]
then
        clear
        echo
        echo "Disabeling IRI, Nelson and Field..."
        docker-compose stop
        docker-compose down
        docker stop $(docker ps -a -q)
        # Delete all containers
        docker rm $(docker ps -a -q)
        # Delete all images
        docker rmi $(docker images -q)
        echo
#Removing old files
        echo "Removing old files..."
        echo
        rm -r ./*
	rm ~/install.sh
	rm ~/reinstall.sh
	rm ~/start.sh
        echo "Succes!"
        echo
#Cloning github
        echo "Downloading new files..."
        echo
        git clone https://github.com/PerfectStorm85/rock64-docker-iota-fullnode
	mv ./rock64-docker-iota-fullnode/* ./
	rm -r ./rock64-docker-iota-fullnode
	mv ./install.sh ~/
	mv ./reinstall.sh ~/
	mv ./start.sh ~/
	rm -r ./rock64Install.sh
        echo "Succes!"
        echo
#Downloading and installing database again
	cd Iota
        echo "Downloading Database... This can take a while."
        ./download_mainnet_db.sh
	cd ..
	cd ~
        ./install.sh
fi

