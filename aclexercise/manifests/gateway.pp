class aclexercise::gateway {
  node 'acl.vm' {
    class { "gateway": }

    gateway::forward_port { "001 server all ports":
      port => undef, # undef = All ports
      ip_address => "${aclexercise::nodes::ip_start}.19",
    }
  }
}
