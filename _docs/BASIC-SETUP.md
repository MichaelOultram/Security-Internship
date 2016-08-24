# Basic Development Setup Guide

This is a quick guide on how to get started with puppet and developing puppet
modules.

## Requirements

-   Vagrant
-   Virtualbox

## Installing puppet-sandbox

1.  Install the required software

2.  Navigate to a working directory and clone the
    [puppet-sandbox](https://github.com/martialblog/puppet-sandbox) repository
    using `git clone https://github.com/martialblog/puppet-sandbox`.

3.  [puppet-sandbox](https://github.com/martialblog/puppet-sandbox) creates
    three virtual machines to play around with but we only need one to test our
    modules. To change this open the `Vagrantfile` and change this

    ```ruby
    puppet_nodes = [
      	{:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'precise64', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
      	{:hostname => 'client1', :ip => '172.16.32.11', :box => 'precise64'},
      	{:hostname => 'client2', :ip => '172.16.32.12', :box => 'precise64'},
    ]
    ```

    to this

    ```ruby
    puppet_nodes = [
      	{:hostname => 'puppet',  :ip => '172.16.32.10', :box => 'precise64', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
    ]
    ```

4.  Run the command `vagrant up` inside the puppet-sandbox folder. This could
    take a while as it should download the virtual machine from the internet
    and start it up.

5.  If everything was successful then you can run the command `vagrant ssh` to
    get inside the newly created virtual machine.

## Adding our modules

1.  Now that you have a working puppet setup, it might be worth checking out
    the [Vagrant guide](VAGRANT.md) that I wrote. Before continuing with this
    guide halt the virtual machine using `vagrant halt`.

2.  Navigate inside the `puppet-sandbox/modules` directory and initialise the
    folder as a git repository: `git init`

3.  Set the remote origin to this repository: `git remote add origin
    "https://github.com/MichaelOultram/Security-Internship.git"`

4.  Pull the repository: `git pull origin master`

5.  Set the default remote to origin `git push --set-upstream origin master`

6.  You should be all setup to start testing the modules in this repository as
    well as [creating your own modules](PUPPET.md).
