class phishing($ip_start = "172.18.0") {
  include puppetdocker
  include phishing::mailserver

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

class phishing::mailserver {
  package { 'postfix':
    ensure => installed,
  }
  package { 'dovecot-core':
    ensure => installed,
    notify => Service['postfix'],
  }
  package { 'dovecot-imapd':
    ensure => installed,
    notify => Service['postfix'],
  }
  file_line { "Plaintext authentication": # Because who needs encryption....
    line => "disable_plaintext_auth = no",
    path => "/etc/dovecot/dovecot.conf",
    require => [Package['dovecot-core'], Package['dovecot-imapd']],
    notify => Service['dovecot'],
  }

  file_line { "Local Emails Only":
    line => "disable_dns_lookups=yes",
    path => "/etc/postfix/main.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file_line { "No tls on SMTP":
    line => "smtpd_use_tls=no",
    match => "^smtpd_use_tls=yes$",
    path => "/etc/postfix/main.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  service { 'postfix':
    ensure => running,
    require => Package['postfix'],
  }

  service { 'dovecot':
    ensure => running,
    require => File_line["Plaintext authentication"],
  }
}

# Defines all the node definitions for all of the containers defined above
class phishing::nodes ($ip_start = "172.18.0") {

  node "phishing.vm" {
    class { "gateway": }
    include phishing::mailserver

    file { "/root/startup/mailserver.sh":
      mode => "700",
      content => "#!/bin/bash\nservice postfix start\nservice dovecot\n",
    }

    user { 'victim':
      ensure => present,
      shell => '/bin/false',
      password => '$6$ceaWIA/p$WGrUEwqslH/FcRq2gdv.Dro.de2D1pEyk0j8dcWonYocCHK76DStZWHi/fhFV3XO8mGfUy4eTZCWu6353mrYx0',
    }
  }

  node "comp1.phishing.vm" {
    include java

    file { "/root/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
    }

    $email_server = "phishing.vm"
    $email_user = "victim"
    $email_pass = "victim"

    file { "/root/LectureEx.java":
      content => template("phishing/LectureEx.java.erb"),
    }

    exec { 'compile LectureEx':
      command => 'javac -cp mail.jar LectureEx.java',
      provider => "shell",
      cwd => "/root",
      require => [File['/root/mail.jar'], File["/root/LectureEx.java"]],
    }

  }

}
