# PuppetDocker module

This module uses docker to simulate computers on the internet. Each simulated
computer has it's own docker image which this module creates.

Checkout the [docs](./docs) directory for more documentation.

## Requirements

-   garethr-docker puppet module
-   puppetlabs-utils puppet module
-   puppetserver should autosign certificates
-   A 64 bit operating system

## How to use this module

The absolute minimum node definition that puppetdocker supports is:

```puppet
node 'local.vm' {
  class { 'puppetdocker': }
}
```

This tells puppet to install docker and create the puppet-base image. It can be
used to generate the base virtual machine which can then be cloned to generate
virtual machines for each student (with all the containers and networks).

### Networks

To define a network, you use the `puppetdocker::network` resource. The below
example creates a network on the `172.18.0.0/24` cidr. The name of the
resource, `example`, becomes the name of the network and will need to be used
when defining which containers go into which networks.

```puppet
node 'local.vm' {
  puppetdocker::network {"example":
    cidr => "172.18.0.0/24",
  }
}
```

It is important to note that each container on the network will expect a
gateway at the ip address `xxx.xxx.xxx.1` and thus containers using the gateway
module will need to be made.

Warning: Each network needs a different cidr and `xxx.xxx.xxx.254` is reserved
for the host machine (but the host machine can not talk on that ip address).

### Containers

To define a container, you use the `puppetdocker::container` resource. Below is
an example container which connects to the public_network (i.e. the simulated
internet) and connects to the private network example on the ip address
172.18.0.1.

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

When the container image is built, it will look for a node definition with the
same hostname as the `puppetdocker::container` resource name. In this example I
have the example.vm container installing the gateway module as it is a gateway
container (it is connected to the public network and the private example
network, and the container has an ip address ending in .1).

Warning: The network interfaces are named eth0, eth1, ... ordered by ip address
(e.g. 172.17.0.3 has network device eth0, 172.19.0.1 has network device eth1).
