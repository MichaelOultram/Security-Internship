# Configure container via puppet
PATH=/opt/puppetlabs/bin:$PATH
puppet agent --waitforcert 1 --test

# Remove all traces of puppet
apt-get autoremove -y puppet-agent
rm -rf /opt/puppetlabs /etc/puppetlabs /etc/init.d/puppet

# Delete self
rm -- "$0"
