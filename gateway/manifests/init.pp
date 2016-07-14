class gateway {
  include firewall

  # Allow containers inside the network to access the outside world
  firewall { 'nat eth0':
    chain  => 'POSTROUTING',
    table  => 'nat',
    output => 'eth0', # eth0 should be the docker0 (public) network
    jump   => 'MASQUERADE',
  }

}
