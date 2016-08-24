# Advanced Setup

You are probably better off following the [basic guide](BASIC-SETUP.md).

This guide is how to set up puppet in a more advanced configuration manually.
We will separate the puppet server and the puppet client into two different
virtual machines. Alternatively if you are running Linux as the host operating
system, you could use just one virtual machine for the puppet client and run
the puppet server on the host operating system.

When creating a virtual machine in VirtualBox, make the HDD 100GB or you will
regret it later. Attach the iso and install the operating system. Once complete
make a snapshot inside VirtualBox in case you make a mistake later on.

## Requirements

-   VirtualBox
-   An operating system iso (I used [Debian](https://www.debian.org/) as the
    client and [Arch Linux](https://www.archlinux.org/) as the server)

## Puppet server setup instructions

There are two different ways to have a puppet server running. If you are using
Windows then you have to run the puppet server inside a second virtual machine.
Otherwise you can run the puppet server on your host machine. The steps are
similar for either method

1.  Install puppet server using `cd ~ && wget
    https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb && sudo dpkg
    -i puppetlabs-release-pc1-trusty.deb && sudo apt-get update && sudo apt-get
    install puppetserver` or [look at this guide here](https://docs.puppet.com/puppet/latest/reference/install_linux.html)

2.  Clone this repository into some location. It may be a good idea to set this
    as a synced folder if using VirtualBox.

3.  Tell puppet about the cloned repository so it knows where the modules are
    installed. You need to add onto the basemodulepath using

        puppet config set basemodulepath $(puppet config print basemodulepath):/path/to/repository

4.  You should also tell puppet to autosign certificates. This is especially
    important if using the puppetdocker module as it will create more puppet
    clients.

        echo \* > $(puppet config print confdir)/autosign.conf

5.  To run the puppet server, run `puppetserver foreground` or `puppet master --no-daemonize`

## Puppet client setup instructions

1.  Create a virtual machine in virtual box (make the HDD 100GB or you will
    regret it later). Attach the iso and install the operating system. Once
    complete make a snapshot inside virtualbox in case you make a mistake later
    on.

2.  Set the virtual machines hostname to `local.vm`. Edit `/etc/hosts` file to
    include your new hostname.

3.  Puppet client can be installed in multiple ways for different operating
    systems and so I recommend checking out [this guide here](https://docs.puppet.com/puppet/latest/reference/install_linux.html).
    For the lazy who are following this guide and using Debian, install ruby via

        gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
        curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.1

    and then install puppet using `gem install puppet`. This method can give
    you a more up to date version of puppet than the previously mentioned
    guide's method.

4.  Shutdown the client virtual machine. If running the puppet server inside
    a virtual machine then you need to create a virtual network between the
    two machines. If you are running the puppet server on your host machine
    then you need add a host network adapter to the virtual machine.

5.  Configure the hosts file so that the ip address of the puppet server has
    the name puppet as well as what the actual server's hostname is (i.e.
    `10.10.10.5 puppet puppet.local.vm`)

6.  Take a snapshot and try doing a puppet run (`puppet agent test --waitforcert 60`)
    to see if the two machines link. The main reasons for this failing is
    either puppet cannot find the server (in which case you did step 5 wrong)
    or the SSL certificates are not signed/trusted properly (in which case look
    online because I tried my best).
