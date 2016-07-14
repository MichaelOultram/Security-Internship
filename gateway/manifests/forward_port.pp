# Forwards a port to a specific container
# $ports: A range of ports to forward
# $ip_address: The ip address of the container to forward data to
define forward_port($ports, $ip_address) {
  # Allow public network to communicate on ports
  # Set up DNAT so that the destination changes to the container
  # Set up SNAT so that outgoing traffic appears to originate from the router
}
