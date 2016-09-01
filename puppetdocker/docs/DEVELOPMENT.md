# Development

In this document, I try my best to explain exactly what this module is doing to
make it easier for future development.

## How it works

Below is a rough guide to what this module does behind the scenes. Hopefully it
will give you enough of an idea that it's easier to use this module than to set
everything up by hand.

-   The garethr-docker module installs docker and configures it so that docker
    does not mess with iptables.

-   A puppet-base image is built which uses the phusion/baseimage to install
    puppet.

-   Each of the `puppetdocker::container` resources creates a build container
    from the puppet-base image. This container primarily runs the command
    `puppet agent --waitforcert 1 --test` to configure what the container
    should look like.

-   An image is then made for each of the built containers with the same name
    as the hostname. This allows for a container to be reset to a known good
    state.

-   Any of the requested networks are then created, and configured so that the
    hostname is in the file `/etc/hosts` on the main virtual machine and the
    route from the virtual machine to inside the newly made network is blocked.
    Each of these private networks will require a gateway container to link the
    private network to the public (simulated) internet. The gateway module will
    have configured all the port forwarding preferences for the container in
    the previous 2 steps.

-   Each of the `puppetdocker::container` resources starts a container from the
    images that were built earlier and puts them in the correct networks. The
    garethr-docker module configures them so that they start when the virtual 
    machine starts (and will be reset back to the image's state when the 
    virtual machine restarts).
