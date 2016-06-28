#!/bin/bash
# Download puppet/puppetserver and install
cd /tmp
sudo wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i /tmp/puppetlabs-release-pc1-trusty.deb
sudo apt-get update
sudo apt-get -y upgrade puppetserver puppet-agent

# Disables secure path
sudo /bin/sh -c "echo \"alias sudo='sudo env PATH=$PATH'\" >> /etc/profile"

# Adds /vagrant/modules to basemodulepath
basemodulepath="$(sudo puppet config print basemodulepath)"
sudo puppet config set basemodulepath $basemodulepath:/vagrant/modules
