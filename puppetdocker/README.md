# PuppetDocker module
This module uses docker to simulate computers on the internet. Each simulated computer has it's own docker image which this module creates.

## Requirements
- garethr-docker puppet module
- puppetlabs-utils puppet module
- puppetserver should autosign certificates

## How to use this module
The absolute minimum node definition that puppetdocker supports is:
```puppet
node 'local.vm' {
  class { 'puppetdocker': }
}
```
This tells puppet to install docker and create the puppet-base image. It can be used to generate the base virtual machine which can then be cloned to generate virtual machines for each student (with all the containers and networks).

### Networks
To define a network, you use the `puppetdocker::network` resource. The below example creates a network on the `172.18.0.0/24` cidr with the domain name `example.vm`. The name of the resource, `example`, becomes the name of the network and will need to be used when defining which containers go into which networks.

```puppet
node 'local.vm' {
  puppetdocker::network {"example":
    cidr => "172.18.0.0/24",
    domain => "example.vm",
  }
}
```

It is important to note that each container on the network will expect a gateway at the ip address `xxx.xxx.xxx.1` and thus containers using the gateway module will need to be made.

Warning: Each network needs a different cidr and `xxx.xxx.xxx.254` is reserved for the host machine (but the host machine can not talk on that ip address).

### Containers
To define a container, you use the `puppetdocker::container` resource. Below is an example container which connects to the public_network (i.e. the simulated internet) and connects to the private network example on the ip address 172.18.0.1.

```puppet
node 'local.vm' {
  puppetdocker::container { "example.vm":
    public_network => true,
    private_networks => ["example 172.18.0.1"],
  }
}

node 'example.vm' {
  class { 'gateway': }
}
```

When the container image is built, it will look for a node definition with the same hostname as the `puppetdocker::container` resource name. In this example I have the example.vm container installing the gateway module as it is a gateway container (it is connected to the public network and the private example network, and the container has an ip address ending in .1).

Warning: The network interfaces are named eth0, eth1, ... ordered by ip address (e.g. 172.17.0.3 has network device eth0, 172.19.0.1 has network device eth1).

## Example node definition
This is the node definition I have been using to test this module. I may change this example in the future to something more useful.

```puppet
node 'local.vm' {
  class { 'puppetdocker': }

  puppetdocker::network { "example":
    cidr => "172.18.0.0/24",
    domain => "example.vm",
  }

  puppetdocker::container { "example.vm":
    public_network => true,
    private_networks => ["example 172.18.0.1"],
  }

  puppetdocker::container { "a.example.vm":
    public_network => false,
    private_networks => ["example 172.18.0.2"],
  }

  puppetdocker::container { "b.example.vm":
    public_network => false,
    private_networks => ["example 172.18.0.3"],
  }

}

node 'example.vm' {
  class { 'gateway': }

  gateway::forward_port { "001 netcat test":
    port => [2999, 3000],
    ip_address => "172.18.0.2",
  }

  gateway::forward_port { "001 java protocols":
    port => [11335, 11336, 11337, 11338],
    ip_address => "172.18.0.3",
  }
}

node 'a.example.vm' {
  class { 'helloworld': }
}

node 'b.example.vm' {
  class { 'protocols':
    protocols => 'ex31:Lutescent:11335,ex32:Olivaceous:11336,ex33:Purpure:11337,ex34:Titian:11338',
  }
}
```

## How it works
Below is a rough guide to what this module does behind the scenes. Hopefully it will give you enough of an idea that it's easier to use this module than to set everything up by hand.

- The garethr-docker module installs docker and configures it so that docker does not mess with iptables.

- A puppet-base image is built which uses the phusion/baseimage to install puppet.

- Each of the `puppetdocker::container` resources creates a build container from the puppet-base image. This container primarily runs the command `puppet agent --waitforcert 1 --test` to configure what the container should look like.

- An image is then made for each of the built containers with the same name as the hostname. This allows for a container to be reset to a known good state.

- Any of the requested networks are then created, and configured so that the hostname is in the file `/etc/hosts` on the main virtual machine and the route from the virtual machine to inside the newly made network is blocked. Each of these private networks will require a gateway container to link the private network to the public (simulated) internet. The gateway module will have configured all the port forwarding preferences for the container in the previous 2 steps.

- Each of the `puppetdocker::container` resources starts a container from the images that were built earlier and puts them in the correct networks. The garethr-docker module configures them so that they start when the virtual machine starts (and will be reset back to the image's state when the virtual machine restarts).
