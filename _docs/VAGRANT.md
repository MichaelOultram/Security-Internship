# Introduction to Vagrant/puppet-sandbox

Vagrant is the tool we are using to create a virtual machine with puppet installed. The [puppet-sandbox](https://github.com/martialblog/puppet-sandbox) repository has a `Vagrantfile` which describes exactly how the virtual machine should be configured. In Vagrant, we need to start from a base box (which is essentially an image of the operating system already installed). These can be quite huge but they only need to be downloaded once. The base box that puppet-sandbox uses is precise64 but you could change this to [any box you like](https://atlas.hashicorp.com/boxes/search) (most of the modules I have been testing using `debian/jessie64`).

When you first run `vagrant up` inside the puppet-sandbox folder it checks whether the base box has already been downloaded. If so it then makes a copy of that box (so it can be easily reset) and starts it up. Vagrant then configures the virtual machine based on what you have specified in the `Vagrantfile`, in this case it configures puppet.

## Choosing the modules to install

Puppet uses the `puppet-sandbox/nodes.pp` file (known as the node definitions) to find out which puppet modules it should install on what machine (or node). The `nodes.pp` file will have three different node definitions because the puppet-sandbox configures three machines but we changed this to one and so two of the node definitions are unused. You can delete everything after and include the `##### CLIENTS` line.

If we wanted to install the `helloworld` module (which puts `world` into the file `/tmp/hello`) we would put our node definition as:

```puppet
node 'puppet' {
  class { 'helloworld': }
}
```

We have specified what we want but we need to tell puppet to run. To do this, ssh into the machine using `vagrant ssh` and change to the root user using `sudo -i`. While running puppet as root isn't 100% necessary, it is what I've always done (and some of our modules won't support running as a non-root user). Run the command `puppet agent --test`.



## Vagrant commands

All of these commands need to be run inside the `puppet-sandbox` folder and not `puppet-sandbox/modules` or any other folder

Command             | Usage
------------------- | ------------------------------------------------------------------------------
`vagrant up`        | Powers up the virtual machine
`vagrant halt`      | Shuts down the virtual machine
`vagrant provision` | Ensures that puppet is installed and configured
`vagrant destroy`   | Destroys the current virtual machine so that it can be recreated from scratch.
`vagrant ssh`       | SSH's into the virtual machine using the vagrant account
