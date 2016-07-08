#!/bin/bash
# Gateway should always on xxx.xxx.xxx.1

# Get the old gateway
line=$(ip route | grep default)
array=($line)
old_ip=${array[2]}

# Change the last segment to 1
seg=(${old_ip//./ })
new_ip=${seg[0]}.${seg[1]}.${seg[2]}.1

# Update gateway to new ip
ip route del default
ip route add default via $new_ip

# Delete self
rm -- "$0"