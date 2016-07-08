class puppetdocker {

  # Install docker (ubuntu-trusty)
  file { "/etc/apt/sources.list.d/docker.list":
    ensure => present,
  }->
  file_line { "Add docker repo":
    path => "/etc/apt/sources.list.d/docker.list",
    line => "deb https://apt.dockerproject.org/repo ubuntu-trusty main",
  }->
  exec { "apt-update":
    command => 'apt-get update',
    path => "/usr/bin:/bin",
  }->
  package { 'docker-engine':
    ensure => installed,
  }

  file { "puppet-base":
    path => "/root/puppet-base",
    source => "puppet:///modules/puppetdocker/puppet-base",
    recurse => true,
  }

  exec { "docker build -t puppet-base /root/puppet-base":
    path => "/bin:/usr/bin",
    require => [File["puppet-base"], Package['docker-engine']],
  }

}
