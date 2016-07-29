class puppetdocker {
  class { "docker":
    iptables => false,
    dns => '172.17.0.1',
  }

  class { "puppetdocker::iptables": }

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
    require => [File['public dns servers'], File['dnsmasq configuration']],
  }->
  exec { "rm -rf /root/tmp/puppet-base":
    provider => "shell",
  }

  # Ensure that a dns server is running on the VM
  package { 'dnsmasq':
    ensure => installed,
  }
  service { 'dnsmasq':
    ensure  => 'running',
    enable  => true,
    require => Package['dnsmasq'],
  }
  file { 'public dns servers':
    content => "nameserver 8.8.8.8\nnameserver 8.8.4.4\n",
    path    => "/etc/resolv-public.conf",
    notify  => Service['dnsmasq'],
  }
  file { 'dnsmasq configuration':
    source => "puppet:///modules/puppetdocker/dnsmasq.conf",
    path    => "/etc/dnsmasq.conf",
    notify  => Service['dnsmasq'],
    require => Package['dnsmasq'],
  }
  file { 'vm use local dns':
    content => "nameserver 127.0.0.1\n",
    path    => "/etc/resolv.conf",
    require => [File['public dns servers'], File['dnsmasq configuration']],
  }
}
