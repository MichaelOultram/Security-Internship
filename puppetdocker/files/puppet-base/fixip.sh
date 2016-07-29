#!/bin/bash
# Gateway should always on xxx.xxx.xxx.1

# Remove default root
ip route del default

# Get all network interface names
devices=($(ip link | grep eth[0-9][0-9]* | while read line ; do words=($line); echo ${words[1]//:/ } ; done))

# Set all network interfaces down and rename to tmp
for ((i=0; i<${#devices[*]}; i++));
do
    ip link set ${devices[i]} down
		ip link set ${devices[i]} name tmp${i}
done

# Rename all the network interfaces in numerical order and bring them up
order=($(ip a | grep 172 | sort | while read line ; do words=($line); echo ${words[4]} ; done))
for ((i=0; i<${#order[*]}; i++));
do
		ip link set ${order[i]} name eth${i}
		ip link set eth${i} up
done

# Get the cidr for eth0
line=$(ip route | grep eth0)
cidr=($line)
old_ip=${cidr//\/24/}

# Change the last segment to 1
seg=(${old_ip//./ })
new_ip=${seg[0]}.${seg[1]}.${seg[2]}.1

# Update default route to new ip
ip route add default via $new_ip
