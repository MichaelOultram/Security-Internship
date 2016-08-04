class phishing::webserver {
  node "webserver.worklink.vm" {
    include sshserver
    $packages = ['apache2', 'php', 'libapache2-mod-php', 'php-mcrypt']
    exec { "apt-get update":
      provider => "shell",
    }->
    package { $packages:
      ensure => installed,
    }->
    file { "/var/www/html":
      ensure => directory,
      recurse => true,
      source => "puppet:///modules/phishing/website",
    }->
    file { "/etc/my_init.d/webserver.sh":
      mode => "700",
      content => "#!/bin/bash\n/etc/init.d/php7.0-fpm start\nservice apache2 start\n",
    }->
    file { "/var/www/html/Action/uploads":
      ensure => directory,
      mode => "777",
    }

    # MAILSERVER
    class { "mailserver":
      hostname => "worklink.vm",
    }

    # Admin
    genuser { "t.chothia": password => "99monkeys", }

    # Finance
    genuser { "p.pierce": password => "oldguy", }
    genuser { "j.baker": password => "notoldguy", }

    # Carrers
    genuser { "careers": password => "sreerac", }
    genuser { "c.hampshire": password => "jobgiver", }

    # Interns
    genuser { "j.wilkison": password => "computerscience", }
    genuser { "s.lord": password => "newbie", }
  }
}
