#!/bin/bash

mkdir Iota
cd Iota
git clone https://github.com/PerfectStorm85/rock64-docker-iota-fullnode
mv ./rock64-docker-iota-fullnode/* ./
rm -r ./rock64-docker-iota-fullnode
mv ./install.sh ~/
mv ./reinstall.sh ~/
mv ./start.sh ~/
cd ~
rm -r ./rock64Install.sh
echo "Done"

