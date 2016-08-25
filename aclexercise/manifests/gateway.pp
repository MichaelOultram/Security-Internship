class aclexercise::gateway {
  node 'acl.vm' {
    include gateway

    gateway::forward_port { "001 server all ports":
      port => undef, # undef = All ports
      ip_address => "${aclexercise::nodes::ip_start}.19",
    }
  }
}
