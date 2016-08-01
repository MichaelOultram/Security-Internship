class phishing ($metasploit_users = []) {
  include puppetdocker
  include mailserver
  if $metasploit_users != [] {
    class { "metasploit":
      users => $metasploit_users,
    }
  }

  package { 'icedove': # Debian version of thunderbird
    ensure => installed,
  }

  puppetdocker::network {"worklink":
    cidr => "${phishing::nodes::ip_start}.0/24",
  }

  puppetdocker::container { "worklink.vm":
    public_network => true,
    private_networks => ["worklink ${phishing::nodes::ip_start}.1"]
  }

  puppetdocker::container { "webserver.worklink.vm":
    private_networks => ["worklink ${phishing::nodes::ip_start}.22"]
  }

  puppetdocker::container { "mailserver.worklink.vm":
    private_networks => ["worklink ${phishing::nodes::ip_start}.23"]
  }

  puppetdocker::container { "victimpc.worklink.vm":
    private_networks => ["worklink ${phishing::nodes::ip_start}.45"]
  }



}
