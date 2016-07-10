define puppetdocker::network($domain, $cidr, $isolated = true) {
  include docker, stdlib

  # Find the gateway from $cidr
  $ip=split($cidr, '\/')
  $segments = split($ip[0], '\.')
  if $isolated {
    $vm_gateway = join([$segments[0], ".", $segments[1], ".", $segments[2], ".254"])
    $container_gateway = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])

    # Isolate the network from the VM (ip route del 172.18.0.254)
    exec { "ip route del ${cidr}":
      path    => "/usr/bin:/bin",
      require => docker_network[$name],
      unless => "test -n `ip route | grep ${cidr}`",
    }

    # Create a gateway container
    /*puppetdocker::container { "gateway":
      name => "gateway",
      network => $name,
      ip_address => $container_gateway,
      require => [docker_network[$name], file_line['Google DNS']],
    }*/
  } else {
    $vm_gateway = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])
    $container_gateway = $vm_gateway
  }

  # Create the docker network
  docker_network { $name:
    ensure  => present,
    driver  => 'bridge',
    subnet  => $cidr,
    gateway => $vm_gateway,
  }

  # Add the domain to the hosts file
  file_line { "DNS resolver":
    line => "${container_gateway} ${domain}",
    path => "/etc/hosts",
  }

  # Ensure that a dns server is running on the VM
  package { 'bind9':
    ensure => installed,
  }
  service { 'bind9':
    ensure  => 'running',
    enable  => true,
    require => Package['bind9'],
  }
  file_line { 'Google DNS':
    line    => "forwarders { 8.8.8.8; 8.8.4.4; };",
    path    => "/etc/bind/named.conf.options",
    after   => "options {",
    notify  => Service['bind9'],
    require => Package['bind9'],
  }

}
