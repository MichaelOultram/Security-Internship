class aclexercise($ip_start = "172.18.0") {
  include puppetdocker

  puppetdocker::network {"acl":
    cidr => "${ip_start}.0/24",
    domain => "acl.vm",
  }

  puppetdocker::container { "acl.vm":
    public_network => true,
    private_networks => ["acl ${ip_start}.1"]
  }

  puppetdocker::container { "server.acl.vm":
    private_networks => ["acl ${ip_start}.19"]
  }

  puppetdocker::container { "comp1.acl.vm":
    private_networks => ["acl ${ip_start}.45"]
  }

  puppetdocker::container { "comp2.acl.vm":
    private_networks => ["acl ${ip_start}.92"]
  }
}

class aclexercise::nodes::ssh_server {
  class { 'ssh::server':
    storeconfigs_enabled => false,
    options => {
      'X11Forwarding'          => 'yes',
      'PasswordAuthentication' => 'yes',
      'PermitRootLogin'        => 'yes',
      'Port'                   => [22],
    },
  }-> # Generate rsa host key
  exec { "ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa":
    provider => "shell",
    cwd => "/",
  }-> # Start ssh server when container starts
  file { "/root/startup/ssh.sh":
    content => "#!/bin/bash\nservice ssh start\n",
    mode => "0777",
  }
}

# Defines all the node definitions for all of the containers defined above
class aclexercise::nodes ($ip_start = "172.18.0") {
  $charlie_keys = gen_rsa_pair("acl_charlie")

  node "acl.vm" {
    class { "gateway": }

    gateway::forward_port { "001 server all ports":
      port => undef, # undef = All ports
      ip_address => "${aclexercise::nodes::ip_start}.19",
    }

  }

  node "server.acl.vm" {
    include aclexercise::nodes::ssh_server

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
      content => $aclexercise::nodes::charlie_keys[0],
      require => File[$folders],
    }

    file { '/backup/charlie/.ssh/id_rsa':
      content => $aclexercise::nodes::charlie_keys[1],
      require => File[$folders],
    }

  }

  node "comp1.acl.vm" {
    include aclexercise::nodes::ssh_server

    # Comp1 has a "desktop"
    package { 'xorg':
      ensure => installed,
    }
  }

  node "comp2.acl.vm" {
    include aclexercise::nodes::ssh_server

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
