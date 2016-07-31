class phishing::webserver {
  node "webserver.phishing.vm" {
    $packages = ['apache2', 'php']
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
      content => "#!/bin/bash\nservice apache2 start\n/etc/init.d/php7.0-fpm start",
    }
  }
}
