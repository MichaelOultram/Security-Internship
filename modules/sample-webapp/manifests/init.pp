
exec { "apt-update":
  command => "apt-get update",
  path => "/usr/bin",
}
package { "apache2":
  ensure  => present,
  require => Exec["apt-update"],
}
service { "apache2":
  ensure => running,
  require => Package["apache2"],
}

# Shouldn't be in html folder
file { "/var/www/html/sample-webapp":
  ensure  => "link",
  target  => "/vagrant/sample-webapp",
  require => Package["apache2"],
  notify  => Service["apache2"],
}
