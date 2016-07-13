define puppetdocker::container($network = "bridge", $ip_address = "") {
  $segments = split($ip_address, '\.')
  $dns = join([$segments[0], ".", $segments[1], ".", $segments[2], ".1"])

  # Start container
  if $network == "bridge" || $ip_address == ""{
    docker::run { $name:
      image    => "puppet-base",
      name     => $name,
      hostname => $name,
      dns      => $dns,
      extra_parameters => ["--net=${network}", "--cap-add=NET_ADMIN"],
    }
  } else {
    docker::run { $name:
      image    => "puppet-base",
      name     => $name,
      hostname => $name,
      dns      => $dns,
      extra_parameters => ["--net=${network}", "--cap-add=NET_ADMIN", "--ip=${ip_address}"],
    }
  }
}
