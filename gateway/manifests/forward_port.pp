# Forwards a port to a specific container
# $ports: A range of ports to forward
# $ip_address: The ip address of the container to forward data to
define gateway::forward_port($proto = "tcp", $port, $ip_address) {
  $segments = split($ip_address, '\.')
  $gateway_ip = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])

  # Allow public network to communicate on ports
  # Set up DNAT so that the destination changes to the container
  firewall { "${name} dnat ${port}/${proto}":
    chain   => 'PREROUTING',
    table   => 'nat',
    iniface => 'eth0',
    proto   => $proto,
    todest  => $ip_address,
    dport   => $port,
    jump    => 'DNAT',
    notify => Exec['iptables-save'],
  }
  # Set up SNAT so that outgoing traffic appears to originate from the router
  firewall { "${name} snat ${port}/${proto}":
    chain       => 'POSTROUTING',
    table       => 'nat',
    outiface    => 'eth1',
    proto       => $proto,
    destination => $ip_address,
    tosource    => $gateway_ip,
    dport       => $port,
    jump        => 'SNAT',
    notify => Exec['iptables-save'],
  }
}
