class puppetdocker {
  class { "docker":
    iptables => false,
  }

  file { "/root/tmp":
    ensure => directory,
  }

  # Create puppet-base docker image
  file { "puppet-base":
    path => "/root/tmp/puppet-base",
    source => "puppet:///modules/puppetdocker/puppet-base",
    recurse => true,
    require => File["/root/tmp"],
  }->
  docker::image { 'puppet-base':
    docker_dir => '/root/tmp/puppet-base',
  }->
  exec { "rm -rf /root/tmp/puppet-base":
    provider => "shell",
  }

  # Ensure iptables are saved by using iptables-persistent package and iptables-save >/etc/iptables/rules.v4
}
