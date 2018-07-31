#!/bin/bash

getCurrentSettings(){

curIRIPort=$(cat ~/Iota/volumes/iri/iota.ini | grep "^PORT" | grep -oP "PORT = \K.*")
curTCPPort=$(cat ~/Iota/volumes/iri/iota.ini | grep "^TCP_RECEIVER_PORT =" | grep -oP "TCP_RECEIVER_PORT = \K.*")
curUDPPort=$(cat ~/Iota/volumes/iri/iota.ini | grep "^UDP_RECEIVER_PORT =" | grep -oP "UDP_RECEIVER_PORT = \K.*")
curFieldPort=$(cat ~/Iota/volumes/field.cli/config.ini | grep "^port =" | grep -oP "port = \K.*")
curNelsonAPIPort=$(cat ~/Iota/docker-compose.yml | grep "apiPort" | grep -oP ".*apiPort \K.*")
curNelsonAPIPort=${curNelsonAPIPort%?}
curNelsonGuiPort=$(cat ~/Iota/docker-compose.yml | grep "command: \"-p " | grep -oP ".*command: \"-p \K.*" | sed -n -e  's/ --apiHostname nelson.cli --apiPort.*//p')
curNelsonCliPort=$(cat ~/Iota/volumes/nelson.cli/config.ini | grep "^port = " | grep -oP "port = \K.*")

#echo "IRI Port: $curIRIPort"
#echo "TCP Port: $curTCPPort"
#echo "UDP Port: $curUDPPort"
#echo "Field Port: $curFieldPort"
#echo "Nelson API Port: $curNelsonAPIPort"
#echo "Nelson Gui Port: $curNelsonGuiPort"
#echo "Nelson Cli Port: $curNelsonCliPort"

}

configNelsonGui(){

clear
echo
echo "Enter Nelson Gui Port - Current: $curNelsonGuiPort"
echo "Leave empty to use the default 5000"
echo
while [ true ]
do
read -p "Port: " nelsonGUIPort
if [ "$nelsonGUIPort" == "" ]
then
nelsonGUIPort="5000"
break
fi
echo
echo "$nelsonGUIPort - Is this correct?"
echo
read -p "y/n: " nelsonGuiAnswer
if [ "$nelsonGuiAnswer" == "y" ]
then
        sed -i -e 's/-p $curNelsonGuiPort/-p '$nelsonGuiPort'/g' ~/Iota/docker-compose.yml
	sed -i -e 's/$curNelsonGuiPort:$curNelsonGuiPort/'$nelsonGuiPort':'$nelsonGuiPort'/g' ~/Iota/docker-compose.yml
        echo
        echo "Nelson Gui Port set to $nelsonGuiPort"
        echo
        read -p "Press Enter to continue" answer2
        break
fi
done
}

configTCP(){

clear
echo
echo "Enter TCP Port - Current: $curTCPPort"
echo "Leave empty to use the default 15600"
echo
while [ true ]
do
read -p 'Port: ' tcpPort
if [ "$tcpPort" == "" ]
then
tcpPort="15600"
break
fi
echo
echo "$tcpPort - Is this correct?"
echo
read -p 'y/n ' tcpAnswer
if [ "$tcpAnswer" == "y" ]
then
        sed -i -e 's/TCP_RECEIVER_PORT = $curTCPPort/TCP_RECEIVER_PORT = '$TCPPort'/g' ~/Iota/volumes/iri/iota.ini
        sed -i -e 's/TCPPort = $curTCPPort/TCPPort = '$TCPPort'/g' ~/Iota/volumes/nelson.cli/config.ini
        echo
        echo "TCP Port set to $TCPPort"
        echo
        read -p "Press Enter to continue" answer2
        break
fi
done
}

configUDP(){

clear
echo
echo "Enter UDP Port - Current: $curUDPPort"
echo "Leave empty to use the default 14600"
echo
while [ true ]
do
read -p "Port: " udpPort
if [ "$udpPort" == ""
then
	udpPort="14600"
	break
	fi
echo
echo "$udpPort - Is this correct?"
echo
read -p 'y/n: ' udpAnswer
if [ "$udpAnswer" == "y" ]
then
        sed -i -e 's/UDP_RECEIVER_PORT = $curUDPPort/UDP_RECEIVER_PORT = '$UDPPort'/g' ~/Iota/volumes/iri/iota.ini
        sed -i -e 's/UDPPort = $curUDPPort/UDPPort = '$UDPPort'/g' ~/Iota/volumes/nelson.cli/config.ini
        echo
        echo "UDP Port set to $UDPPort"
        echo
        read -p "Press Enter to continue" answer2
        break
fi
done
}

configField(){

clear
echo
echo "Enter CarrIOTA Field Port - Current: $curFieldPort"
echo "Leave empty to use the default 21310"
echo
while [ true ]
do
read -p "Port: " fieldPort
if [ "$fieldPort" == "" ]]
then
	fieldPort="21310"
	break
fi
echo
echo "$fieldPort - Is this correct?"
echo
read -p 'y/n: ' fieldAnswer
if [ "$fieldAnswer" == "y" ]
then
        sed -i -e 's/$curFieldPort:$curFieldPort/'$fieldPort':'$fieldPort'/g' ~/Iota/docker-compose.yml
        sed -i -e 's/port = $curFieldPort/port = '$fieldPort'/g' ~/Iota/volumes/field.cli/config.ini
        echo
        echo "CarrIOTA Field Port set to $fieldPort"
        echo
        read -p "Press Enter to continue" answer2
        break
fi
done

}

configNelsonCli(){

clear
echo
echo "Enter Nelson Client port - Current: $curNelsonCliPort"
echo "Leave empty to use default 16600"
echo
while [ true ]
do
read -p "Port: " nelsonPort
if [ "$nelsonPort" == "" ]
then
	nelsonPort="16600"
	break
fi
echo
echo "$nelsonPort - Is this correct?"
echo
read -p "y/n: " nelsonAnswer
if [ "$nelsonAnswer" == "y" ]
then
	sed -i -e 's/$curNelsonPort:$curNelsonPort/'$nelsonPort':'$nelsonPort'/g' ~/Iota/docker-compose.yml
        sed -i -e 's/port = $curNelsonPort/port = '$nelsonPort'/g' ~/Iota/volumes/nelson.cli/config.ini
        echo
        echo "Nelson Client Port set to $nelsonPort"
        echo
        read -p "Press Enter to continue" answer2
        break
fi
done
}

configNelsonAPI(){

clear
echo
echo "Enter Nelson API Port - Current: $curNelsonAPIPort"
echo "Leave empty to use the default 18600"
echo
while [ true ]
do
read -p "Port: " nelsonAPIPort
if [ "$nelsonAPIPort" == "" ]
then
	nelsonAPIPort="18600"
	break
fi
echo
echo "$nelsonAPIPort - Is this correct?"
echo
read -p "y/n: " nelsonAPIAnswer
if [ "$nelsonAPIAnswer" == "y" ]
then
	sed -i -e 's/$curNelsonAPIPort:$curNelsonAPIPort/'$nelsonAPIPort':'$nelsonAPIPort'/g' ~/Iota/docker-compose.yml
	sed -i -e 's/apiPort = $curNelsonAPIPort/apiPort = '$nelsonAPIPort'/g' ~/Iota/volumes/nelson.cli/config.ini
	echo
	echo "Nelson API Port set to $nelsonAPIPort"
	echo
	read -p "Press Enter to continue" answer2
	break
fi
done
}

configIRI(){

clear
echo
echo "Enter IRI Port - Current: $curIRIPort"
echo "Leave empty to use the default 14625"
echo
while [ true ]
do
read -p 'Port: ' iriPort
if [ "$iriPort" == "" ]
then
iriPort="14265"
break
fi
echo
echo "$iriPort - Is this correct?"
echo
read -p 'y/n ' iriPortAnswer
if [ "$iriPortAnswer" == "y" ]
then
	sed -i -e 's/$curIRIPort:$curIRIPort/'$iriPort':'$iriPort'/g' ~/Iota/docker-compose.yml
	sed -i -e 's/IRIPort = $curIRIPort/IRIPort = '$iriPort'/g' ~/Iota/volumes/field.cli/config.ini
	sed -i -e 's/IRIPort = $curIRIPort/IRIPort = '$iriPort'/g' ~/Iota/volumes/nelson.cli/config.ini
	sed -i -e 's/PORT = $curIRIPort/PORT = '$iriPort'/g' ~/Iota/volumes/iri/iota.ini
	echo
	echo "Nelson API set to $nelsonAPIPort"
        echo
        read -p "Press Enter to continue" answer2
	break
fi
done

}

configAll(){

configIRI
configNelsonCli
configNelsonAPI
configNelsonGui
configField
configTCP
configUDP

}

while [ true ]
do

clear
echo
getCurrentSettings
echo "Setup ports"
echo
echo "Which ports would you like to setup?"
echo
echo "1. All"
echo
echo "2. IRI 			Current: $curIRIPort"
echo "3. Nelson Cli 		Current: $curNelsonCliPort"
echo "4. Nelson Gui 		Current: $curNelsonGuiPort"
echo "5. CarrIOTA Field 	Current: $curFieldPort"
echo "6. Nelson API 		Current: $curNelsonAPIPort"
echo "7. TCP 			Current: $curTCPPort"
echo "8. UDP 			Current: $curUDPPort"
echo
echo "0. Return to main menu"
echo
read -p 'Option: ' answer
case $answer in
	0)
		exit;;
	1)
		configAll;;
	2)
		configIRI;;
	3)
		configNelsonCli;;
	4)
		configNelsonGui;;
	5)
		configField;;
	6)
		configNelsonAPI;;
	7)
		configTCP;;
	8)
		configUDP;;
	*)
		echo "Invalid input detected"
esac

done
