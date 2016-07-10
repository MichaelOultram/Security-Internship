class gateway ($port_forwarding = []) {
  include firewall

  firewall { 'Allow clients to access the internet':
    chain  => 'POSTROUTING',
    table  => 'nat',
    output => 'eth0',
    jump   => 'MASQUERADE',
  }

}
