# Using http://phusion.github.io/baseimage-docker/
FROM phusion/baseimage

# Set required environment variables
ENV TERM dumb
ENV PATH /opt/puppetlabs/bin:$PATH

# Fix gateway
COPY ./start.sh /root/start.sh

# Install puppet agent
RUN apt-get update && \
    apt-get install -y wget && \
    cd /tmp && \
    wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb && \
    dpkg -i /tmp/puppetlabs-release-pc1-wheezy.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    rm -r /tmp/*

# Container start command
CMD /root/start.sh && /sbin/my_init
