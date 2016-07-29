#!/bin/bash
echo "nameserver 172.17.0.1" > /etc/resolv.conf
touch /etc/iptables/rules.v4
iptables-restore < /etc/iptables/rules.v4
