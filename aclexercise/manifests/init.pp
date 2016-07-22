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

  node "acl.vm" {
    class { "gateway": }

    gateway::forward_port { "001 server all ports":
      port => undef,
      ip_address => "${aclexercise::nodes::ip_start}.19",
    }
  }

  node "server.acl.vm" {
    include aclexercise::nodes::ssh_server
  }

  node "comp1.acl.vm" {
    include aclexercise::nodes::ssh_server
  }

  node "comp2.acl.vm" {
    include aclexercise::nodes::ssh_server
  }

}
