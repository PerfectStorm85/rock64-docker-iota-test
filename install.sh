#!/bin/bash

# Rock64 Installation script
# Copyright 2018 Rock64Iota.com
# Version 2.0 by Ron Kamphuis

# Check Release version

drawlogo () {
cat ~/Iota/logo
}

vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

testvercomp () {
    vercomp $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ $op != $3 ]]
    then
	bionicVersion="False"
        #echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
    else
	bionicVersion="True"
        #echo "Pass: '$1 $op $2'"
    fi
}

# Start Script

clear
drawlogo
echo
echo "Welcome to the installation process of the Full IRI node for Rock64"
echo
echo "Please follow the installation instructions on the website before you run this script"
echo "Make sure you forward your ports on your router before or after the installation!"
echo "More info about this on the website: https://www.Rock64Iota.com"
echo
echo "You can cancel the installation at any time by typing: ctrl+c"

ubuntuVersion=$(lsb_release -r -s)
bionicVersion="False"

testvercomp $ubuntuVersion 16.04 '<'

if [ "$1" == "" ]
then


echo
echo "Do you want to continue the installation?"
read -p 'y/n: ' answer
if [ "$answer" != "y" ]
then
	exit
fi

clear
echo
echo "When using this hardware and software, you agree to all the terms of use as stated on https://www.Rock64Iota.com"
echo
echo "Do you agree with the terms of use?"
read -p 'y/n: ' touAnswer
if [ "$touAnswer" != "y" ]
then
	echo
	echo "Aborted"
	echo
	exit
fi

# Name your node
	clear
	echo
	echo "You can cancel the installation at any time by typing: ctrl+c"
	echo
	echo "Please enter a name for your Iota Node."
	echo "Examples: Johns Rock64 Iota Node, IotaNode, Full_IRI_Node, etc..."
	echo
	while [ true ]
	do
		read -p 'Name: ' nodename
		echo "$nodename - Is this correct?"
		read -p 'y/n: ' answerNodeName
		if [ "$answerNodeName" == "y" ]
		then
			break
		fi
	done

# Add ip address

	clear
        echo
	echo "You can cancel the installation at any time by typing: ctrl+c"
	echo
#	echo "Do you want to configure the IP Address?"
#	echo "If you havn't done this yet, select y"
#	echo "If you have already setup your IP Address before, and you don't want to do this again, type n"
#	echo
#	read -p 'y/n: ' ipAddressConfigured
#       if [ "$ipAddressConfigured" == "y" ]
#	then
	ipAddressConfigured="n"
	clear
	wget --spider --quiet http://www.google.com
	if [ "$?" != 0 ]; then
		hasInternetConnection="False"
	else
		hasInternetConnection="True"
	fi
	echo
       	echo "You can cancel the installation at any time by typing: ctrl+c"
        echo
	echo "Your current settings are:"
	echo
	curIpAddress="$(ifconfig eth0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')"
	curGateway="$(/sbin/ip route | awk '/default/ { print $3 }')"
	curNetmask="$(ifconfig eth0 | sed -rn '2s/ .*:(.*)$/\1/p')"
	echo "IP Address: $curIpAddress"
	echo "Gateway: $curGateway"
	if [ "$bionicVersion" = "False" ]
	then
		echo "Netmask: $curNetmask"
	fi
	echo
	staticOrDhcp="$(find /etc/network/interfaces -type f -print | xargs grep "iface eth0 inet static")"
	if [ "$hasInternetConnection" == "True" ]
	then
		if [ "$staticOrDhcp" == "iface eth0 inet static" ]
		then
			curUsedIpAddress="$(sed -n '/address/p' /etc/network/interfaces)"
			if echo "$curUsedIpAddress" | grep -q "$curIpAddress"; then
				echo "Your ip settings seem to be working correct, and it is set to static. Do you want to change it anyway?"
			else
				echo "Your ip is set to Static, but your current ip ($curUsedIpAddress) is different than the one you configured. ($curIpAddress)"
				echo "This could happen if that specific ip address is already used by some other device in your network."
				echo "Do you want to change it?"
			fi
		else
			staticOrDhcp="$(find /etc/network/interfaces -type f -print | xargs grep "iface eth0 inet dhcp")"
			if [ "$staticOrDhcp" == "iface eth0 inet dhcp" ]
			then
				echo "You are currently using dynamic ip."
				echo "It is recommanded to use a Static IP so that you can open ports specifically for that ip address"
				echo "Do you want to configure your network?"
			else
				echo "Unknown internet settings found."
				echo "Do you want to change this?"
			fi
		fi
		read -p 'y/n: ' changeIpAnswer
		if [ "$changeIpAnswer" == "y" ]
		then
			ipAddressConfigured="y"
		fi
	else
		echo "You don't seem to have a working internet connection yet. Please setup the network settings."
		echo
		ipAddressConfigured="y"
	fi
	if [ "$ipAddressConfigured" == "y" ]
	then
		echo "Do you want a static or dynamic IP address?"
		echo
		echo "Dynamic: You can plug it into any LAN connection and the device will find a random available local IP address."
		echo "Warning: Your ports should be opened for this connection! A dynamic setup might change your IP Address so it could be that you'll need to open ports on a different ip!"
		echo
		echo "Static: Usefull for ssh connection to the node. Use this if you want the local IP address to always be the same."
		echo
		while [ true ]
		do
			echo "1 = Dyanamic"
			echo "2 = Static"
			echo
			read -p '1/2: ' dynStatIP
			if [ "$dynStatIP" == "1" ]
			then
				echo
				echo "Dynamic IP Selected!"
				ipaddress="Dynamic IP"
				break
			elif [ "$dynStatIP" == "2" ]
			then
				echo
				echo "Static IP Selected!"
				echo
					echo
        				echo "Please enter the local IP you would like to give to your Rock."
				        echo "This can be useful for remote desktop to your Rock Device"
				        echo "Usually, this is something like: 192.168.1.101"
					echo
		        		while [ true ]
					do
						read -p 'ip address: ' ipaddress
				        	echo "$ipaddress - Is this correct?"
                                                read -p 'y/n ' corIpAddressAnswer
                                                if [ "$corIpAddressAnswer" == "y" ]
                                                        then
                                                        break
						fi

					done
					while [ true ]
                                        do
						echo
						echo "Please enter your Gateway Address. Most of the time this your ip address ending with 1. For example: IPAddress 192.168.1.114 - Gateway 192.168.1.1"
						echo
                                                read -p 'Gateway address: ' gatewayAddress
                                                echo "$gatewayAddress - Is this correct?"
						read -p 'y/n ' gatewayAddressAnswer
						if [ "$gatewayAddressAnswer" == "y" ]
							then
							break
						fi
					done
					if [ "$bionicVersion" == "False" ]
					then
						while [ true ]
	                                        do
        	                                        echo
                	                                echo "Please enter your Netmask Address. Most of the time this is 255.255.255.0"
                        	                        echo
                                	                read -p 'Netmask address: ' netmaskAddress
                                        	        echo "$netmaskAddress - Is this correct?"
	                                                read -p 'y/n ' netmaskAddressAnswer
        	                                        if [ "$netmaskAddressAnswer" == "y" ]
                	                                        then
                        	                                break
                                	                fi
                                        	done
					fi
                                        while [ true ]
                                        do
                                                echo
                                                echo "Please enter your DNS Address. Most of the time this is the same as your Gateway address"
                                                echo
                                                read -p 'DNS address: ' dnsAddress
                                                echo "$dnsAddress - Is this correct?"
                                                read -p 'y/n ' dnsAnswer
                                                if [ "$dnsAnswer" == "y" ]
                                                        then
                                                        break
                                                fi
                                        done

					break
				fi
			clear
			echo
			echo "You can cancel the installation at any time by typing: ctrl+c"
		done
		echo
		echo "IP successfully set!"
		echo
		echo "Ip address: $ipaddress"
		echo "Gateway: $gatewayAddress"
		if [ "$bionicVersion" == "False" ]
		then
			echo "Netmask: $netmaskAddress"
		fi
		if [ "$dnsAnswer" == "y" ]
		then
		echo "DNS Address: $dnsAddress"
		fi
		echo
		read -p 'Press enter to continue' continueAnswer
	fi

# Apply update

clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "Do you want to apply automatic updates?"
echo "The user will not notice this, the node will update when possible and restart the services automatically"
echo
echo "No user data will be collected for updating. There is a possibility that an extra script gets executed if the updates require an OS update of any kind"
echo
echo "Do you want to apply automatic updates?"
echo
read -p 'y/n: ' autoUpdate
if [ "$autoUpdate" == "y" ]
then
	autoUpdateText="yes"
else
	autoUpdateText="no"
fi

# Add Iota donation address

clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "Enter your Iota donation address. If you don't want to set one you can skip this step by leaving it empty"
echo
while [ true ]
do
	read -p 'Donation address: ' iotaDonation
	if [ "$iotaDonation" == "" ]
	then
		iotaDonation="IWYWXFING9VEEXSQDCRRUEBBZECKZUYMKMMFOPDBGZKHKASRYLTEXLGGPUCLUIGDZQXSOWI9UXUNYWFEYZAAKXTEND"
	break
	fi
	echo "$iotaDonation - Is this correct?"
        read -p 'y/n: ' answerDonationAddress
        if [ "$answerDonationAddress" == "y" ]
        then
                break
        fi
done

# Setup Iota port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run IRI? Default 14265"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' iriPort
if [ "$iriPort" == "" ]
then
iriPort="14265"
break
fi
echo "$iriPort - Is this correct?"
read -p 'y/n ' iriPortAnswer
if [ "$iriPortAnswer" == "y" ]
then
break
fi
done

# Setup TCP port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run TCP? Default 15600"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' tcpPort
if [ "$tcpPort" == "" ]
then
tcpPort="15600"
break
fi
echo "$tcpPort - Is this correct?"
read -p 'y/n ' tcpPortAnswer
if [ "$tcpPortAnswer" == "y" ]
then
break
fi
done

# Setup UDP port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run UDP? Default 14600"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' udpPort
if [ "$udpPort" == "" ]
then
udpPort="14600"
break
fi
echo "$udpPort - Is this correct?"
read -p 'y/n ' udpPortAnswer
if [ "$udpPortAnswer" == "y" ]
then
break
fi
done

# Setup Nelson port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run Nelson? Default 16600"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' nelsonPort
if [ "$nelsonPort" == "" ]
then
nelsonPort="16600"
break
fi
echo "$nelsonPort - Is this correct?"
read -p 'y/n ' nelsonPortAnswer
if [ "$nelsonPortAnswer" == "y" ]
then
break
fi
done

# Setup Nelson API port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run Nelson API? Default 18600"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' nelsonAPIPort
if [ "$nelsonAPIPort" == "" ]
then
nelsonAPIPort="18600"
break
fi
echo "$nelsonAPIPort - Is this correct?"
read -p 'y/n ' nelsonAPIPortAnswer
if [ "$nelsonAPIPortAnswer" == "y" ]
then
break
fi
done

# Setup carrIota port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run carrIota? Default 21310"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' ciPort
if [ "$ciPort" == "" ]
then
ciPort="21310"
break
fi
echo "$ciPort - Is this correct?"
read -p 'y/n ' ciPortAnswer
if [ "$ciPortAnswer" == "y" ]
then
break
fi
done

# Setup Nelson GUI port
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "On what port do you want to run Nelson GUI? Default 5000"
echo "Press enter for default"
echo
while [ true ]
do
read -p 'Port: ' ngPort
if [ "$ngPort" == "" ]
then
ngPort="5000"
break
fi
echo "$ngPort - Is this correct?"
read -p 'y/n ' ngPortAnswer
if [ "$ngPortAnswer" == "y" ]
then
break
fi
done

# Add static neighbors
clear
echo
echo "You can cancel the installation at any time by typing: ctrl+c"
echo
echo "The next step is to optionally add static neighbors."
echo "You can find static neighbors in the discord channel."
echo "Please visit https://Rock64Iota.com for more info if you need help"
echo
echo "By not adding static neighbors there is a risk that your node will sometimes not be completely synced."
echo "Although this is not a major issue, if you really want you can avoid this by adding static neighbors"
echo
echo "Do you want to add static neighbors now?"
read -p 'y/n: ' answer
while [ true ]
do
	if [ "$answer" == "y" ]
	then
		neighbors=""
		while [ true ]
		do
			echo
			echo "Please enter the neighbor address. Press enter to continue."
			echo "Example: tcp://239.123.6.129:15600 or udp://iotanode.service:14600"
			read -p 'address: ' nb
			if [ "$nb" == "" ]
                        then
                                break
                        fi
			echo "Is this the correct address? $nb"
			read -p 'y/n: ' answer2
			if [ "$answer2" == "y" ]
			then
				clear
				echo
				echo "Neighbor added!"
				neighbors="$neighbors $nb"
				echo "Neighbors:$neighbors"
			fi
		done
		break
	else
		if [ "$answer" == "n" ]
		then
			break
		fi
	fi
done

# Automatic script input, skip the above section and immediately fill in the properties
else

nodename="$1"
ipaddress="$2"
netmaskAddress="255.255.255.0"
gatewayAddress="$3"
dnsAddress="$4"
iriPort="$5"
tcpPort="$6"
udpPort="$7"
nelsonPort="$8"
nelsonAPIPort="$9"
ciPort="${10}"
ngPort="${11}"
iotaDonation="${12}"

fi

# Make directories if they are not yet there
mkdir -p ./Iota/volumes
mkdir -p ./Iota/volumes/nelson.cli
mkdir -p ./Iota/volumes/field.cli
mkdir -p ./Iota/volumes/iri

if [ "$ipAddressConfigured" == "y" ]
then

if [ "$dynStatIP" == "2" ]
then

IFS='.' read -ra ADDR <<< "$ipaddress"
gatewayaddress="${ADDR[0]}.${ADDR[1]}.${ADDR[2]}.1"

if [ "$bionicVersion" == "False" ]
then
cat << "EOF" | sudo tee /etc/network/interfaces | grep -q ".*"
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
# source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
EOF
echo " address $ipaddress" | sudo tee -a /etc/network/interfaces | grep -q ".*"
echo " netmask $netmaskAddress" | sudo tee -a /etc/network/interfaces | grep -q ".*"
echo " gateway $gatewayAddress" | sudo tee -a /etc/network/interfaces | grep -q ".*"
echo " dns-nameservers $dnsAddress" | sudo tee -a /etc/network/interfaces | grep -q ".*"
else
cat << "EOF" | sudo tee /etc/netplan/eth0.yaml | grep -q ".*"
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
EOF
echo "      addresses: [$ipaddress/24]" | sudo tee -a /etc/netplan/eth0.yaml | grep -q ".*"
echo "      gateway4: $gatewayAddress" | sudo tee -a /etc/netplan/eth0.yaml | grep -q ".*"
echo "      nameservers:" | sudo tee -a /etc/netplan/eth0.yaml | grep -q ".*"
echo "        addresses: [$dnsAddress]" | sudo tee -a /etc/netplan/eth0.yaml | grep -q ".*"
fi

elif [ "$dynStatIP" == "1" ]
then
if [ "$bionicVersion" == "False" ]
then
cat << "EOF" | sudo tee /etc/network/interfaces | grep -q ".*"
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
# source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
else
cat << "EOF" | sudo tee /etc/netplan/eth0.yaml | grep -q ".*"
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
EOF
fi
fi
fi

cat << "EOF" | sudo tee ./Iota/volumes/iri/iota.ini | grep -q ".*"
[IRI]
EOF
echo  "PORT =$iriPort" | sudo tee -a ./Iota/volumes/iri/iota.ini | grep -q ".*"
echo  "TCP_RECEIVER_PORT =$tcpPort" | sudo tee -a ./Iota/volumes/iri/iota.ini | grep -q ".*"
echo  "UDP_RECEIVER_PORT =$udpPort" | sudo tee -a ./Iota/volumes/iri/iota.ini | grep -q ".*"
echo  "NEIGHBORS =$neighbors" | sudo tee -a ./Iota/volumes/iri/iota.ini | grep -q ".*"
cat << "EOF" | sudo tee -a ./Iota/volumes/iri/iota.ini | grep -q ".*"
IXI_DIR = /iri/ixi/
HEADLESS = true
DEBUG = false
TESTNET = false
DB_PATH = /iri/mainnetdb
API_HOST = 0.0.0.0
REMOTE = true
ZMQ_ENABLED = false
EOF

#Setting correct autoUpdate settings:

echo "$autoUpdateText" | sudo tee ~/Iota/autoUpdate.conf | grep -q ".*"

# Setting the correct name to Nelson and Field

echo "[nelson]" | sudo tee ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
echo "name = $nodename" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
cat << "EOF"| sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
cycleInterval = 60
epochInterval = 300
EOF
echo  "apiPort = $nelsonAPIPort" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
echo  "apiHostname = 0.0.0.0" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
echo  "port = $nelsonPort" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
cat << "EOF" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
IRIHostname = iri
;UDP doesn't seem to work properly in a docker container (maybe https://github.com/iotaledger/iri/issues/276 ?)
;IRIProtocol = any
IRIProtocol = tcp
EOF
echo  "IRIPort = $iriPort" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
echo  "TCPPort = $tcpPort" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
echo  "UDPPort = $udpPort" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
cat << "EOF" | sudo tee -a ./Iota/volumes/nelson.cli/config.ini | grep -q ".*"
dataPath = /data/neighbors.db
; maximal incoming connections. Please do not set below this limit:
incomingMax = 5
; maximal outgoing connections. Only set below this limit, if you have trusted, manual neighbors:
outgoingMax = 4
isMaster = false
silent = false
gui = false
getNeighbors = https://raw.githubusercontent.com/SemkoDev/nelson.cli/master/ENTRYNODES
; add as many initial Nelson neighbors, as you like
neighbors[] = mainnet.deviota.com/16600
neighbors[] = mainnet2.deviota.com/16600
neighbors[] = mainnet3.deviota.com/16600
neighbors[] = iotairi.tt-tec.net/16600
EOF

echo "[field]" | sudo tee ./Iota/volumes/field.cli/config.ini | grep -q ".*"
echo "name = $nodename" | sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
echo "IRIPort = $iriPort" | sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
echo "IRIHostname = iri" | sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
echo "address = $iotaDonation" | sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
cat << "EOF"| sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
; Alternatively to address, you can provide a (NEW) seed
; In this case, the Field cient will be generating new, unused addresses dynamically.
; seed = XYZ
EOF
echo "port = $ciPort" | sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
cat << "EOF"| sudo tee -a ./Iota/volumes/field.cli/config.ini | grep -q ".*"
pow = yes
disableIRI = false
; If you want Field to generate a custom id, instead of using machine-id
customFieldId = true
EOF

cp ~/Iota/docker-composeBase.yml ~/Iota/docker-compose.yml
sed -i -e 's/-p 5000/-p '$ngPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/5000:5000/'$ngPort':'$ngPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/14600:14600/'$udpPort':'$udpPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/15600:15600/'$tcpPort':'$tcpPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/14265:14265/'$iriPort':'$iriPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/18600:18600/'$nelsonAPIPort':'$nelsonAPIPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/16600:16600/'$nelsonPort':'$nelsonPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/21310:21310/'$ciPort':'$ciPort'/g' ~/Iota/docker-compose.yml
sed -i -e 's/--apiPort 18600/--apiPort '$nelsonAPIPort'/g' ~/Iota/docker-compose.yml

clear
echo
echo " -----------------------"
echo "|                       |"
echo "|    Rock64Iota.com     |"
echo "|                       |"
echo "|   Install complete!   |"
echo "|_______________________|"
echo
echo "Node name: $nodename"
echo "IP Address: $ipaddress"
echo "Neighbors:$neighbors"
echo
echo
echo "Port setup:"
echo
echo "IRI: $iriPort"
echo "Nelson: $nelsonPort"
echo "NelsonAPI: $nelsonAPIPort"
echo "NelsonGUI: $ngPort"
echo "carrIota: $ciPort"
echo "TCP: $tcpPort"
echo "UDP: $udpPort"
echo
echo "Make sure you open all these ports on your router and the firewall is not blocking them!"
echo

# Kill the program if the settings were done automatically

if [ "$1" != "" ]
then
        exit
fi

read -p 'Press any key to continue' anyKey
echo
clear

needsUpdateDB=$(cat ~/Iota/needsUpdateDB.ini)
if [ "$needsUpdateDB" == "yes" ]
then
        echo "The Database needs to be re-downloaded."
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
        fi
fi

if [ "$ipAddressConfigured" == "y" ]
then
	echo "The IP Address has been changed. Your device needs to be rebooted."
	echo "Do you want to reboot now?"
	echo
	read -p 'y/n: ' rebootAnswer
	if [ "$rebootAnswer" == "y" ]
	then
		reboot
	fi
fi
else
	exit
fi
clear
echo
echo "Do you want to start the node now?"
echo
echo "You can always start it manually with: sudo ./start.sh"
echo
read -p 'y/n: ' startNode
if [ "$startNode" == "y" ]
then
./start.sh
