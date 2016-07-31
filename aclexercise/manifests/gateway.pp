class aclexercise::gateway($ip_start) {
  node 'acl.vm' {
    class { "gateway": }

    gateway::forward_port { "001 server all ports":
      port => undef, # undef = All ports
      ip_address => "${aclexercise::gateway::ip_start}.19",
    }
  }
}
