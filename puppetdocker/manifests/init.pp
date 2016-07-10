class puppetdocker {
  include docker

  file { "/root/tmp":
    ensure => directory,
  }

  # Create puppet-base docker image
  file { "puppet-base":
    path => "/root/tmp/puppet-base",
    source => "puppet:///modules/puppetdocker/puppet-base",
    recurse => true,
    require => File["/root/tmp"],
  }
  docker::image { 'puppet-base':
    docker_dir => '/root/tmp/puppet-base',
    require => [File["puppet-base"], Package['docker-engine']],
  }
  exec { "rm -rf /root/tmp/puppet-base":
    path => "/bin:/usr/bin",
    require => docker::image['puppet-base'],
  }
}
