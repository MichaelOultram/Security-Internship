# Creates a new private network
# =============================
# $domain:
# The domain name of the network (e.g. example.vm)
#
# $cidr:
# Classless Inter-Domain Routing. Specifies the ip range and subnet of the
# private network. (e.g. 172.18.0.0/24)
#
define puppetdocker::network($domain, $cidr) {
  include docker, stdlib

  # Validate argument types
  validate_string($domain)
  validate_ip_address($cidr)

  # Find the gateway from $cidr
  $ip = split($cidr, '\/')
  $segments = split($ip[0], '\.')
  $vm_gateway = join([$segments[0], ".", $segments[1], ".", $segments[2], ".254"])
  $container_gateway = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])

  # Create the docker network
  docker_network { $name:
    ensure  => present,
    driver  => 'bridge',
    subnet  => $cidr,
    gateway => $vm_gateway,
  }

  # Isolate the network from the VM (ip route del 172.18.0.254)
  exec { "ip route del ${cidr}":
    path    => "/usr/bin:/bin",
    require => Docker_network[$name],
    unless => "test -n `ip route | grep ${cidr}`",
  }

  # Create a gateway container
  puppetdocker::container { $domain:
    public_network => true,
    private_networks => {$name => $container_gateway},
    require => Docker_network[$name],
  }


}
