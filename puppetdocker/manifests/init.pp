class puppetdocker {
  class { "docker":
    iptables => false,
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
    content => "nameserver 8.8.8.8\nnameserver 8.8.4.4",
    path    => "/etc/resolv-public.conf",
    notify  => Service['dnsmasq'],
  }
  file_line { 'dnsmasq use public':
    line    => "resolv-file=/etc/resolv-public.conf",
    path    => "/etc/dnsmasq.conf",
    notify  => Service['dnsmasq'],
    require => Package['dnsmasq'],
  }
  file { 'vm use local dns':
    content => "nameserver 127.0.0.1",
    path    => "/etc/resolv.conf",
    require => [File['public dns servers'], File_line['dnsmasq use public']],
  }
}
