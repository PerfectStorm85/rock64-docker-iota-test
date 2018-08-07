#!/bin/bash

echo
echo "Stopping services, please wait..."
echo
cd ~/Iota
if [ "$1" == "" ]
then
	docker-compose stop
else
	docker-compose "$1"
fi
