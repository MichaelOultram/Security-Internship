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
    require => File['vm use local dns'],
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
  file { 'dnsmasq configuration':
    source => "puppet:///modules/puppetdocker/dnsmasq.conf",
    path    => "/etc/dnsmasq.conf",
    require => Package['dnsmasq'],
  }
  exec { 'add puppet server to dnsmasq.hosts file':
    command => "cat /etc/hosts | grep puppet > /etc/dnsmasq.hosts",
    provider => "shell",
    creates => "/etc/dnsmasq.hosts",
    before => File['vm use local dns'],
  }
  exec { 'restart dnsmasq':
    command => "service dnsmasq restart",
    provider => "shell",
    require => [Exec['add puppet server to dnsmasq.hosts file'], File['dnsmasq configuration'], Package['dnsmasq']],
  }
  file_line { "Stop network manager breaking resolv.conf":
    path => "/etc/NetworkManager/NetworkManager.conf",
    line => "dns=none",
    after => "\[main\]",
  }
  file { 'vm use local dns':
    content => "nameserver 127.0.0.1\n",
    path    => "/etc/resolv.conf",
    require => [File_line["Stop network manager breaking resolv.conf"], Exec['restart dnsmasq']],
  }
}
