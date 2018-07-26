#!/bin/bash

# Testing only!
testVersion="False"

if [ "$testVersion" == "True" ]
then
        IRIVersion="IRIVersionTest.html"
	updateScript="updateScriptTest.sh"
else
        IRIVersion="IRIVersion.html"
        updateScript="updateScript.sh"
fi

while [ true ]
do
        # Check if latest version is already running. If not, download updateScript.sh and run it.
        # This can contain updates to the github, like the docker-container.
	content=$(wget https://www.Rock64Iota.com/Iota/$IRIVersion -q -O -)
        # If empty our internet connection might be lost. In that case don't do anything.
        if [ "$content" != "" ]
        then
        curVersion=$(cat CurVersion.ini)

        if [ "$curVersion" != "$content" ]
        then
                echo "$content" > CurVersion.ini
		rm ./updateScript*
                wget https://www.Rock64Iota.com/Iota/$updateScript
                chmod +x ./$updateScript

                #The update script is usually empty. But in case something else needs to be updated on the rock itself this script is called and executed.
                #I will never use this method to push harmful content to your device!

                ./$updateScript
                echo "Updating... Disabeling IRI, Nelson and Field..."
                docker-compose stop
                docker-compose down
                docker stop $(docker ps -a -q)
                # Delete all containers
                docker rm $(docker ps -a -q)
                # Delete all images
                docker rmi $(docker images -q)
                echo "Restarting IRI..."
                docker-compose up -d
                rm ./$updateScript
        fi
        fi
	if [ "$testVersion" == "True" ]
	then
		sleep 6s
	else
        	sleep 600s
	fi
done
