class puppetdocker::iptables {
  include firewall

  Firewall {
    notify => Exec['iptables-save'],
  }

  # Add missing return filter in the DOCKER chain
  firewall { '000 docker return':
    chain => 'DOCKER',
    table => 'filter',
    proto => 'all',
    jump  => 'RETURN',
  }

  # Ensure iptables are saved
  exec { 'iptables-save':
    command => "/sbin/iptables-save > /etc/iptables/rules.v4",
  }
}
