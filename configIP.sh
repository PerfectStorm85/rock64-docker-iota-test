#!/bin/bash

echo "Do you want to configure the IP address?"
echo
read -p 'y/n: ' ipAddressConfigured
if [ "$ipAddressConfigured" == "y" ]
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
fi
