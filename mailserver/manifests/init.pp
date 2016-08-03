class mailserver($hostname) {
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

  file_line { "Update mynetworks":
    line => "mynetworks = 127.0.0.0/8 172.0.0.0/8",
    match => "^mynetworks",
    path => "/etc/postfix/main.cf",
    require => Package['postfix'],
    notify => Service['postfix'],
  }

  file_line { "Set Hostname":
    line => "myhostname = ${hostname}",
    match => "^myhostname",
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

  file { "/var/mail":
    ensure => directory,
    mode => "777", # TODO: Fix this
  }

  if $::in_container == "true" {
    file { "start_mail_server":
      content => "#!/bin/bash\nservice postfix start\nservice dovecot start",
      path => "/etc/my_init.d/mailserver.sh",
      mode => "700"
    }
  }
}
