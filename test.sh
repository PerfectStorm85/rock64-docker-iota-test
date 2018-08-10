#!/bin/bash

hostNameExist=$(grep -rnw ~/Iota/volumes/field.cli/config.ini -e 'fieldHostname')
echo "$hostNameExist"
if [ "$hostNameExist" == "" ]
then
	echo "fieldHostname[]=field.deviota.com:80" | sudo tee -a ~/Iota/volumes/field.cli/config.ini | grep -q ".*"
fi
