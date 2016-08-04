class phishing ($metasploit_users = []) {
  include puppetdocker
  class { "mailserver":
    hostname => "local.vm",
  }
  if $metasploit_users != [] {
    class { "metasploit":
      users => $metasploit_users,
    }
  }

  package { 'icedove': # Debian version of thunderbird
    ensure => installed,
  }

  # Servers Configuration
  puppetdocker::network {"worklink": cidr => "${phishing::nodes::ip_start}.0/24" }
  puppetdocker::container { "worklink.vm":
    public_network => true,
    private_networks => ["worklink ${phishing::nodes::ip_start}.1"]
  }
  puppetdocker::container { "webserver.worklink.vm":  private_networks => ["worklink ${phishing::nodes::ip_start}.22"] }

  # People Configuration
  # puppetdocker::container { "baker.worklink.vm":     private_networks => ["worklink ${phishing::nodes::ip_start}.45"] }
  # puppetdocker::container { "chothia.worklink.vm":   private_networks => ["worklink ${phishing::nodes::ip_start}.46"] }
  # puppetdocker::container { "hampshire.worklink.vm": private_networks => ["worklink ${phishing::nodes::ip_start}.47"] }
  # puppetdocker::container { "lord.worklink.vm":      private_networks => ["worklink ${phishing::nodes::ip_start}.48"] }
  # puppetdocker::container { "pierce.worklink.vm":    private_networks => ["worklink ${phishing::nodes::ip_start}.49"] }
  # puppetdocker::container { "wilkison.worklink.vm":  private_networks => ["worklink ${phishing::nodes::ip_start}.50"] }

}
