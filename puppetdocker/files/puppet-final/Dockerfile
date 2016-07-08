FROM puppet-base
WORKDIR /root

# Setup container with puppet
COPY ./modules/ /opt/puppetlabs/puppet/modules
COPY ./site.pp /root/site.pp
RUN puppet apply site.pp

# Remove all traces of puppet
RUN apt-get autoremove -y puppet-agent && \
    rm -rf /opt/puppetlabs && \
    rm -rf /etc/puppetlabs && \
    rm -f /root/site.pp
