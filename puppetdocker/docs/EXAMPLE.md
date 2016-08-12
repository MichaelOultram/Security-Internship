## Example node definition
This is the node definition I have been using to test this module. It creates a network called `example` and three containers which are put inside the network. The network is using a cidr of `172.18.0.0/24` meaning ip addresses range from `172.18.0.1` to `172.18.0.254`.

One of the containers, `example.vm`, is also in the public network. This container is the gateway container and is configured to have the ip address `172.18.0.1` inside the example network. This is because all containers assume that their router is on the xxx.xxx.xxx.1 address. Inside `example.vm`'s node definition, we can see that some ports are forwarded.

```puppet
node 'local.vm' {
  class { 'puppetdocker': }

  puppetdocker::network { "example":
    cidr => "172.18.0.0/24",
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
