class aclexercise::comp2 {
  node "comp2.acl.vm" {
    include sshserver

    # Comp1 has a "desktop"
    package { 'xorg':
      ensure => installed,
    }

    $folders = ["/home", "/home/charlie", "/home/charlie/.ssh"]
    file { $folders:
      ensure => "directory",
    }

    user { 'charlie':
      home => '/home/charlie',
      ensure => present,
      shell => '/bin/bash',
      password => '$6$dXWRWErN$6LHDhyxb.qeJ4q4q.zESNGdtByCjSR4nH9Btt9SbsRqTgbovAorV/EqACib5.Bpyt5r1GMws87TbRbQUpw11W.',
    }

    file { '/home/charlie/.ssh/id_rsa.pub':
      content => $aclexercise::nodes::charlie_keys[0],
      require => File[$folders],
    }

    file { '/home/charlie/.ssh/id_rsa':
      content => $aclexercise::nodes::charlie_keys[1],
      require => File[$folders],
    }

    file { "/home/charlie/token":
      owner => "charlie",
      group => "charlie",
      mode => "0300",
      content => join(["Token for exercise 2.2\n", gentoken("ex22"), "\n"]),
    }
  }
}
