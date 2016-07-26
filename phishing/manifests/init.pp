class phishing($ip_start = "172.18.0") {
  include puppetdocker

  package { 'postfix':
    ensure => installed,
  }
  service { 'postfix':
    ensure => running,
    require => Package['postfix'],
  }

  puppetdocker::network {"phishing":
    cidr => "${ip_start}.0/24",
    domain => "phishing.vm",
  }

  puppetdocker::container { "phishing.vm":
    public_network => true,
    private_networks => ["phishing ${ip_start}.1"]
  }

  puppetdocker::container { "comp1.phishing.vm":
    private_networks => ["phishing ${ip_start}.45"]
  }

}

# Defines all the node definitions for all of the containers defined above
class phishing::nodes ($ip_start = "172.18.0") {

  node "phishing.vm" {
    class { "gateway": }

    package { 'postfix':
      ensure => installed,
    }
    service { 'postfix':
      ensure => running,
      require => Package['postfix'],
    }

    user { 'victim':
      ensure => present,
      shell => '/bin/false',
      password => '$6$ceaWIA/p$WGrUEwqslH/FcRq2gdv.Dro.de2D1pEyk0j8dcWonYocCHK76DStZWHi/fhFV3XO8mGfUy4eTZCWu6353mrYx0',
    }
  }

  node "comp1.acl.vm" {
    include java

  }

}
