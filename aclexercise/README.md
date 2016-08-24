# Access control list exercise module

This module creates a network of machines with some access control list
security vulnerabilities. The premise of the exercise is that the network is a
misconfigured home network. The network admin intended to forward http traffic
to the server but instead accidentally misconfigured the router to forward all
ports. In addition to this the server is running an ssh server and the root
password is password. It is from here the student is to find a way to gain root
access to all the machines on the network.

**Warning:** This module is currently unfinished

## Requirements

- puppetlabs-java module
- clang module
- gateway module
- genuser module
- puppetdocker module
- sshserver module

## How to use this module

Simply include aclexercise inside the local.vm node definition and write the
class resource for nodes outside any node definition. Inside
`aclexercise::nodes` are node definitions for the containers that aclexercise
creates. An `ip_start` should be chosen that doesn't conflict with any other
included modules.

```puppet
class { "aclexercise::nodes":
  ip_start => "172.18.0",
}

node "local.vm" {
  include aclexercise
}
```
