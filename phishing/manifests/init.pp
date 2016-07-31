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

  puppetdocker::network {"phishing":
    cidr => "${phishing::nodes::ip_start}.0/24",
  }

  puppetdocker::container { "phishing.vm":
    public_network => true,
    private_networks => ["phishing ${phishing::nodes::ip_start}.1"]
  }

  puppetdocker::container { "webserver.phishing.vm":
    private_networks => ["phishing ${phishing::nodes::ip_start}.22"]
  }

  puppetdocker::container { "mailserver.phishing.vm":
    private_networks => ["phishing ${phishing::nodes::ip_start}.23"]
  }

  puppetdocker::container { "victimpc.phishing.vm":
    private_networks => ["phishing ${phishing::nodes::ip_start}.45"]
  }



}
