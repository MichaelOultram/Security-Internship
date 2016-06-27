# Refreshes local package index
exec { "apt-update":
  command => "apt-get update",
  path => "/usr/bin",
}

# Installs packages requires for using the vm via gnome
$gui_packages = [ 'gdm', 'gnome', 'virtualbox-guest-dkms', 'virtualbox-guest-utils', 'virtualbox-guest-x11' ]
package { $gui_packages:
  ensure => 'installed',
  require => Exec["apt-update"],
}
service { "gdm":
  ensure => running,
  require => Package[$gui_packages],
}

# Allows puppet modules to be accessed
file { "/home/vagrant/manifests":
  ensure  => "link",
  target  => "/vagrant/manifests",
}
