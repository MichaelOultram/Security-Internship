
# Using http://phusion.github.io/baseimage-docker/
FROM phusion/baseimage

# Set required environment variables
ENV TERM dumb
ENV PATH /opt/puppetlabs/bin:$PATH

# Expose all ports for the container
EXPOSE 1-65535

# Copy build and run scripts
COPY ./build.sh /root/build.sh
COPY ./start.sh /root/start.sh

# Install puppet agent
RUN apt-get update && \
    apt-get install -y wget iproute2 && \
    cd /tmp && \
    wget -q https://apt.puppetlabs.com/puppetlabs-release-pc1-wheezy.deb && \
    dpkg -i /tmp/puppetlabs-release-pc1-wheezy.deb && \
    apt-get update && \
    apt-get install -y puppet-agent && \
    rm -r /tmp/*

# Container build command
CMD 'bash -c "/root/build.sh"'
