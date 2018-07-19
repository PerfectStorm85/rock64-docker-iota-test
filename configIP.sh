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
        bionicVersion="True"
    else
        bionicVersion="False"
    fi
}

ubuntuVersion=$(lsb_release -r -s)
bionicVersion="False"

testvercomp $ubuntuVersion 16.04 '<'

echo "Do you want to configure the IP address?"
echo
read -p 'y/n: ' ipAddressConfigured
if [ "$ipAddressConfigured" == "y" ]
then
if [ "$bionicVersion" == "True" ]
then
cat << "EOF" | sudo tee /etc/netplan/eth0.yaml | grep -q ".*"
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: yes
EOF
else
cat << "EOF" | sudo tee /etc/network/interfaces | grep -q ".*"
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
# source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF
fi
fi
