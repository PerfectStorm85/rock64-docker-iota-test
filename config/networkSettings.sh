#!/bin/bash

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
#        echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
    else
        bionicVersion="True"
#        echo "Pass: '$1 $op $2'"
    fi
}

ubuntuVersion=$(lsb_release -r -s)
bionicVersion="False"

testvercomp $ubuntuVersion 16.04 '<'

	#clear
	ipAddressConfigured="n"
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
                done
		clear
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
		echo "Please make sure to connect to the new IP if you are connected via SSH!"
		echo
        fi

# Set the settings!

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

if [ "$bionicVersion" == "True" ]
then
	netplan apply
else
	ifdown -a && ip addr flush eth0 && ifup -a
fi
