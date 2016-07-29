# Using http://phusion.github.io/baseimage-docker/
FROM phusion/baseimage

# Copy build and run scripts
COPY ./build.sh /build.sh
COPY ./fixip.sh /etc/my_init.d/fixip.sh
COPY ./fixmisc.sh /etc/my_init.d/fixmisc.sh

# Install puppet agent
RUN TERM=dumb && \
    apt-get update && \
    apt-get install -y wget iproute2 iptables-persistent && \
    cd /tmp && \
    wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb && \
    dpkg -i /tmp/puppetlabs-release-pc1-wheezy.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    rm -r /tmp/*

# Cache all puppet modules files
# (increases speed slightly, but adds an extra key to puppetserver)
RUN PATH=/opt/puppetlabs/bin:$PATH && \
    puppet agent --waitforcert 1 --test && \
    find /etc/puppetlabs/puppet/ssl -name $(hostname --long).pem -delete

# Change prompt to full hostname
ENV PS1 '\[\u@$(hostname -f):\w\]\$'

# Container build command
CMD 'bash -c "/build.sh"'
