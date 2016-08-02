class phishing::webserver {
  node "webserver.worklink.vm" {
    $packages = ['apache2', 'php', 'libapache2-mod-php', 'php-mcrypt']
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
  }
}
