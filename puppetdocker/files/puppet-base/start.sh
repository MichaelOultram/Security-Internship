#!/bin/bash
# Gateway should always on xxx.xxx.xxx.1

# Remove default root
ip route del default

# Get the cidr for eth0
line=$(ip route | grep eth0)
cidr=($line)
old_ip=${cidr//\/24/}

# Change the last segment to 1
seg=(${old_ip//./ })
new_ip=${seg[0]}.${seg[1]}.${seg[2]}.1

# Update default route to new ip
ip route add default via $new_ip

# Execute all startup files
for SCRIPT in /root/startup/*
do
	if [ -f $SCRIPT -a -x $SCRIPT ]
  then
		$SCRIPT
	fi
done

# Use full hostname as prompt
echo 'PS1="\[\u@$(hostname -f):\w\]\$ "' >> /etc/bash.bashrc

# Remove startup files
# rm -rf /root/startup

# Delete self
# rm -- "$0"
