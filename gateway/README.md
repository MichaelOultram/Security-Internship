# Gateway module

This module is meant to be run inside a container, and configures iptables so that any container inside the network can access the outside world and any incoming ports are redirected to the desired container. Because of the way docker runs containers, any gateway containers may need to be restarted before the configuration takes affect (restarting the whole virtual machine can do this).

## Requirements

- puppetlabs-firewall puppet module
- This module is run inside a container
- eth0 is the public network and eth1 is the private network

## How to use this module

If no ports need to be forwarded then the simplest definition is:

```puppet
node 'example.vm'{
  include gateway
}
```

This will configure the container to install iptables and allow for the containers in the private network to access the public network (and the internet). If however you require ports to be forwarded then you'll need to add a `gateway::forward_port` resource.

```puppet
node 'example.vm'{
  include gateway

  gateway::forward_port{ "001 webserver":
    port => [80, 443],
    ip_address => "172.18.0.2",
  }
}
```

This example forwards all traffic on port 80 and 443 to the webserver at the ip address 172.18.0.2.

## Example node definition

This is the node definition I have been using to test this module. I may change this example in the future to something more useful.

```puppet
node 'example.vm'{
  include gateway

  gateway::forward_port{ "001 netcat test":
    port => [2999, 3000],
    ip_address => "172.18.0.2",
  }

  gateway::forward_port{ "001 java protocols":
    port => [11335, 11336, 11337, 11338],
    ip_address => "172.18.0.3",
  }
}
```

## How this module works

- puppetlabs-firewall installs iptables and helps to configure it

- All traffic routing from the private network to the public network are nat'd out.

- Any ports that are forwarded have two iptable rules:

  - One rule is for any traffic routing from the public network to the private network to change the destination address to the desired container (DNAT)

  - Any traffic routing from that container to the public network on that port has the source address changed to the router (SNAT)
