# Limitations
As with everything, there are some limitations. Some of puppetdocker's limitations could be solved in the future and is therefore also included in FUTURE.md.

* Cannot have two cidr's overlapping
* Containers have the permissions to change their network settings
* Containers assume xxx.xxx.xxx.1 ip address is the Gateway
* The host virtual machine ends up with many network interfaces.
* Puppet can not be run more than once.
* Can not restore a container with more than one network interface
* Must use a 64 bit operating system
