#!/bin/bash

cd ~/Iota
if [ "$1" == "" ]
then
	docker-compose stop
else
	docker-compose "$1"
fi
