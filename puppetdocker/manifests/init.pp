class puppetdocker {
  include docker

  docker::image { 'ngix':
    docker_dir => '/root/tmp/ngix',
    subscribe => File['/root/tmp/ngix'],
  }

  file { ["/root", "/root/tmp"]:
    ensure => directory,
    before => File['/root/tmp/ngix'],
  }

  file { "/root/tmp/ngix":
    source => "puppet:///modules/puppetdocker/ngix",
    ensure => directory,
    recurse => true,
  }

  docker::run { 'helloworld':
    image   => 'ngix',
    command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
    require => docker::image['ngix'],
  }

}
