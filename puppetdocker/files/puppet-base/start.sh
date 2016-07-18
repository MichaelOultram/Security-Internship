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

# Update DNS servers
echo "nameserver ${new_ip}" > /etc/resolv.conf

# Execute all startup files
for SCRIPT in /root/startup/*
do
	if [ -f $SCRIPT -a -x $SCRIPT ]
  then
		$SCRIPT
	fi
done

# Remove startup files
rm -rf /root/startup

# Delete self
rm -- "$0"
