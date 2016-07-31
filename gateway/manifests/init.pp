class gateway {
  package { 'iptables-persistent':
    ensure => installed,
  }

  Firewall {
    require => Package['iptables-persistent'],
    notify => Exec['iptables-save'],
  }

  # Save the rules (because puppetlabs-firewall doesn't for some reason)
  exec { 'iptables-save':
    command => '/sbin/iptables-save > /etc/iptables/rules.v4',
    require => Package['iptables-persistent'],
  }

  # Allow containers inside the network to access the outside world
  firewall { '000 nat eth0':
    chain    => 'POSTROUTING',
    table    => 'nat',
    outiface => 'eth0', # eth0 should be the docker0 (public) network
    proto    => 'all',
    jump     => 'MASQUERADE',
  }

}
