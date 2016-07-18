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

  # Restore iptables when the machine starts
  file { '/root/startup/iptables-restore.sh':
    ensure => file,
    content => "#!/bin/bash\niptables-restore < /etc/iptables/rules.v4\n",
    mode => '0755',
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
