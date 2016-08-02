class phishing::gateway {
  node "worklink.vm" {
    include gateway

    gateway::forward_port { "001 webserver":
      port => [80, 443],
      ip_address => "${phishing::nodes::ip_start}.22",
    }

    gateway::forward_port { "002 mailserver tcp":
      proto => "tcp",
      port => [143, 25],
      ip_address => "${phishing::nodes::ip_start}.23",
    }

    gateway::forward_port { "002 mailserver udp":
      proto => "udp",
      port => [143, 25],
      ip_address => "${phishing::nodes::ip_start}.23",
    }

  }
}
