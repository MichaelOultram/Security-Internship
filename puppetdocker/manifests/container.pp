# Creates a new container
# =======================
# $name:
# Container name/hostname (e.g. example.local.vm)
#
# $public_network:
# Container should be connected to the bridge network
#
# $private_networks:
# A hash map of the network name that the container should be
# connected to mapped to the ip address the container should have inside the
# network (e.g. {"isonet" => "172.18.0.1"})
#
define puppetdocker::container($public_network = false, $private_networks = {}) {
  include stdlib

  # Validate argument types
  validate_bool($public_network)
  validate_hash($private_networks)

  # Check to see if the image has already been built (doesn't currently work)
  exec { "${name} container built?":
    command => "/bin/true",
    provider => "shell",
    onlyif => "/bin/false",
  }-># Create a puppet-base container with the hostname set and run /root/build.sh
  docker::run { "build-${name}":
    image    => "puppet-base",
    name     => "build-${name}",
    hostname => $name,
    command  => "bash -c '/root/build.sh'",
    restart  => "no",
    extra_parameters => ["--cap-add=NET_ADMIN"], # May require priviledged for some puppet modules?
  }-> # Wait for the build to start
  exec { "wait-for-build-${name}-start":
    require => Docker::Run["build-${name}"],
    provider => 'shell',
    command => "while [ $(docker ps --filter status=running --filter name=build-${name} -q | wc -l) != '1' ]; do sleep 1; done",
  }-> # Wait for the build to end
  exec { "wait-for-build-${name}-end":
    provider => 'shell',
    command => "while [ $(docker ps --filter status=running --filter name=build-${name} -q | wc -l) != '0' ]; do sleep 1; done",
  }-> # Create an image from the build container and change the startup command
  exec { "${name} image":
    provider => 'shell',
    command => "docker commit --change 'CMD /root/start.sh && /sbin/my_init' build-${name} ${name}",
  }-> # Remove the build container
  exec { "remove build-${name}":
    command => "docker rm build-${name}",
    provider => 'shell',
    before => Docker::Run[$name],
  }

  # Start a container of the newly build image
  if $public_network {
    # Connecting to the public_network
    $private_networks_tail = $private_networks
    docker::run { $name:
      image    => $name,
      name     => $name,
      hostname => $name,
      net      => "bridge",
      extra_parameters => ["--cap-add=NET_ADMIN", "--restart=always"],
    }
    exec { "add ${name} domain to hosts file":
      provider => "shell",
      command => "echo \"$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${name}) ${name}\" >> /etc/hosts",
      unless => "cat /etc/hosts | grep -c $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${name})",
      require => Exec["wait-for-${name}-start"],
      before => Connect_to_network[$private_networks_joined],
    }
  } elsif size($private_networks) == 0 {
    # No networks to connect to
    $private_networks_tail = {}
    docker::run { $name:
      image    => $name,
      name     => $name,
      hostname => $name,
      net      => "none",
      extra_parameters => ["--cap-add=NET_ADMIN", "--restart=always"],
    }
  } else {
    # Get the first network and connect to that
    $private_networks_tail = delete_at($private_networks, 0)
    $private_networks_head = $private_networks[0]
    $head_net = $network_head.keys[0]
    $head_ip = $network_head.value[$head_net]

    validate_string($head_net)
    validate_ip_address($head_ip)

    docker::run { $name:
      image    => $name,
      name     => $name,
      hostname => $name,
      net      => $head_net,
      extra_parameters => ["--cap-add=NET_ADMIN", "--restart=always", "--ip=${head_ip}"],
    }
  }

  exec { "wait-for-${name}-start":
    require => Docker::Run[$name],
    provider => 'shell',
    command => "while [ $(docker ps --filter status=running --filter name=${name} -q | wc -l) != '1' ]; do sleep 1; done",
  }

  $private_networks_joined = join_keys_to_values($private_networks, " ")
  connect_to_network { $private_networks_joined:
    container => $name,
    require => Exec["wait-for-${name}-start"],
  }
}

# Connect to the rest of the networks
define connect_to_network ($container) {
  $arr = split($name, " ")
  $net = $arr[0]
  $ip = $arr[1]

  exec { "docker network connect bridge ${name}":
    command => "docker network connect --ip ${ip} ${net} ${container}",
    provider => "shell",
  }
}
