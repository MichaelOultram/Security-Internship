# TODO: Remove this
echo "10.10.10.2 puppet.local.vm" >> /etc/hosts

# Configure container via puppet
puppet agent --server puppet.local.vm --waitforcert 5 --test

# Remove all traces of puppet
apt-get autoremove -y puppet-agent
rm -rf /opt/puppetlabs
rm -rf /etc/puppetlabs
rm /etc/init.d/puppet

# Remove the first value (/opt/puppetlabs/bin) from the path
paths=(${PATH//:/ })
paths2=${paths[@]:1}
PATH=${paths2// /:}

# Delete self
rm -- "$0"
