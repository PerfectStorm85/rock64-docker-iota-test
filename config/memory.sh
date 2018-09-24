#!/bin/bash
getCurrentSettings(){
curHeapSize=$(cat ~/Iota/docker-compose.yml | grep "Xmx" | grep -oP "Xmx\K.*" | awk '{print $1;}')
curHeapSize=${curHeapSize::-2}
echo "Current Java Heap Size: $curHeapSize"
}

configHeapSize(){
clear
getCurrentSettings
echo
echo "Enter new Java Heap Size."
echo "Use the suffix m (MegaByte) or G (GigaByte). Examples: 3500m, 3G"
echo
echo "Current: $curHeapSize"
echo "Leave empty to use the default 3500m"
echo
while [ true ]
do
	read -p "Size: " heapSize
	heapSizeAnswer="y"
	if [ "$heapSize" == "" ]
	then
		heapSize="3500m"
	else
		echo
		echo "$heapSize - Is this correct?"
		echo
		read -p "y/n: " heapSizeAnswer
	fi
	if [ "$heapSizeAnswer" == "y" ]
	then
		sed -i -e 's/'$curHeapSize'/'$heapSize'/g' ~/Iota/docker-compose.yml
		sed -i -e 's/'$curHeapSize'/'$heapSize'/g' ~/Iota/docker-composeBase.yml
		echo
		echo "Java Heap Size set to $heapSize"
		echo
		read -p "Press Enter to continue" answer2
		break
	fi
done
}
configHeapSize
