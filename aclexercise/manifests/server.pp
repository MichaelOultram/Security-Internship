class aclexercise::server ($charlie_keys) {
  node "server.acl.vm" {
    include sshserver

    user { 'root':
      home => '/root',
      ensure => present,
      shell => '/bin/bash',
      password => sha1('password'),
    }

    file { "/root/token":
      owner => "root",
      group => "root",
      mode => "0300",
      content => join(["Token for exercise 2.1\n", gentoken("ex21"), "\n"]),
    }

    $folders = ["/backup", "/backup/charlie", "/backup/charlie/.ssh"]
    file { $folders:
      ensure => "directory",
    }

    file { '/backup/charlie/.ssh/id_rsa.pub':
      content => $aclexercise::server::charlie_keys[0],
      require => File[$folders],
    }

    file { '/backup/charlie/.ssh/id_rsa':
      content => $aclexercise::server::charlie_keys[1],
      require => File[$folders],
    }

  }
}
