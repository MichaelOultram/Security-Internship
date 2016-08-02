class aclexercise {
  include puppetdocker

  puppetdocker::network { "acl":
    cidr => "${aclexercise::nodes::ip_start}.0/24",
  }

  puppetdocker::container { "acl.vm":
    public_network => true,
    private_networks => ["acl ${aclexercise::nodes::ip_start}.1"]
  }

  puppetdocker::container { "server.acl.vm":
    private_networks => ["acl ${aclexercise::nodes::ip_start}.19"]
  }

  puppetdocker::container { "comp1.acl.vm":
    private_networks => ["acl ${aclexercise::nodes::ip_start}.45"]
  }

  puppetdocker::container { "comp2.acl.vm":
    private_networks => ["acl ${aclexercise::nodes::ip_start}.92"]
  }
}
