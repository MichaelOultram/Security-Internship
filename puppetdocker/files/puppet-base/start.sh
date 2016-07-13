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

echo "10.10.10.2 puppet.local.vm" >> /etc/hosts # TODO: Remove this

# Configure container via puppet
puppet agent --server puppet.local.vm --waitforcert 5 --test

# Remove all traces of puppet
apt-get autoremove -y puppet-agent
rm -rf /opt/puppetlabs
rm -rf /etc/puppetlabs

# Remove /opt/puppetlabs/bin from the path
paths=(${PATH//:/ })
paths2=${paths[@]:1}
PATH=${paths2// /:}

# Delete self
rm -- "$0"
