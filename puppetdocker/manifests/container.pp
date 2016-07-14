define puppetdocker::container($network = "bridge", $ip_address = "") {
  $segments = split($ip_address, '\.')
  $dns = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])

  # Check to see if the image has already been built (doesn't currently work)
  exec { "/bin/true":
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
  exec { 'wait-for-build-start':
    require => Docker::Run["build-${name}"],
    provider => 'shell',
    command => "while [ $(docker ps --filter status=running --filter name=build-${name} -q | wc -l) != '1' ]; do sleep 1; done",
  }-> # Wait for the build to end
  exec { 'wait-for-build-end':
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
  if ($network == "bridge") or ($ip_address == ""){
    docker::run { $name:
      image    => $name,
      name     => $name,
      hostname => $name,
      net      => "bridge",
      extra_parameters => ["--cap-add=NET_ADMIN", "--restart=always"],
    }
  } else { # Only containers on a separate network can have a user chosen ip
    docker::run { $name:
      image    => $name,
      name     => $name,
      hostname => $name,
      dns      => $dns,
      net      => $network,
      extra_parameters => ["--cap-add=NET_ADMIN", "--ip=${ip_address}", "--restart=always"],
    }
  }
}
