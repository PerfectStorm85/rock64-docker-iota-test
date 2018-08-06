#!/bin/bash

needsUpdateDB=$(cat ~/Iota/needsUpdateDB.ini)
if [ "$needsUpdateDB" == "yes" ]
then
        echo "The Database needs to be downloaded first."
	echo "It is highly recommanded to do this before starting the node."
        fileSize="$(curl -sI http://db.iota.partners/IOTA.partners-mainnetdb.tar.gz | grep Content-Length)"
        size=${fileSize#*: }
        echo
        echo "The database size is now:"
        echo "$size" | awk '{ foo = $1 / 1024 / 1024 / 1000 ; print foo " GB" }'
        echo
        echo "Do you want to download the new database now?"
        read -p 'y/n: ' databaseAnswer
        if [ "$databaseAnswer" == "y" ]
        then
                ~/Iota/download_mainnet_db.sh
                echo "no" | sudo tee ~/Iota/needsUpdateDB.ini | grep -q ".*"
        else
		echo "Please download the database before you start the node"
		exit
	fi
fi

content=$(wget https://www.Rock64Iota.com/Iota/IRIVersion.html -q -O -)
curVersion=$(cat ~/Iota/CurVersion.ini)

cd ~/Iota
docker-compose stop
autoUpdate=$(cat autoUpdate.conf)

if [ "$autoUpdate" == "yes" ]
then


	pid=$(ps -ef | pgrep autoUpdate)

	if [ -n "$pid" ]
	then
		echo "Stopping auto-update..."
		echo
		kill $pid
	fi

	if [ "$curVersion" != "$content" ]
	then
	if [ "$content" != "" ]
	then
	       	echo "$content" > CurVersion.ini
        	echo "Applying update, please wait..."
		wget https://www.Rock64Iota.com/Iota/updateScript.sh
	       	chmod +x ./updateScript.sh

        	#The update script is usually empty. But in case something else needs to be updated on the rock itself this script is called and executed.
	       	#I will never use this method to push harmful content to your device!

        	./updateScript.sh $curVersion

		echo "Updating... Disabeling IRI, Nelson and Field..."
        	docker-compose stop
	        docker-compose down
        	docker stop $(docker ps -a -q)
	        # Delete all containers
        	docker rm $(docker ps -a -q)
	        # Delete all images
        	docker rmi $(docker images -q)
	        rm ./updateScript.sh
	fi
	fi

fi

echo "Welcome to IRI. Please wait while we load the image..."
echo
docker-compose up -d
echo
if [ "$autoUpdate" == "yes" ]
then
	echo "Starting auto-update..."
	nohup ./autoUpdate.sh >/dev/null 2>&1 &
echo
fi
echo "Succes!"

