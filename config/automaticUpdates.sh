#!/bin/bash

clear
curAutoUpdateSetting=$(cat ~/Iota/autoUpdate.conf)
echo
if [ "$curAutoUpdateSetting" == yes ]
then
	echo "Automatic Updates is ENABLED"
	echo
	echo "Do you want to disable Automatic updates?"
	read -p 'y/n: ' answer
	if [ "$answer" == "y" ]
	then
		echo "no" | sudo tee ~/Iota/autoUpdate.conf | grep -q ".*"
		echo
		echo "Automatic Updates are now DISABLED"
		echo
	fi
else
        echo "Automatic Updates is DISABLED"
        echo
        echo "Do you want to enable Automatic updates?"
        read -p 'y/n: ' answer
        if [ "$answer" == "y" ]
        then
                echo "yes" | sudo tee ~/Iota/autoUpdate.conf | grep -q ".*"
		echo
                echo "Automatic Updates are now ENABLED"
                echo

        fi
fi
