class wine {
  include apt
  exec { 'dpkg --add-architecture i386':
    provider => "shell",
  }->
  apt::ppa { 'ppa:wine/wine-builds':
    notify => Exec['apt_update'],
  }->
  package { 'xvfb':
    ensure => installed,
  }->
  package { 'winehq-devel':
    ensure => installed,
    install_options => ["--install-recommends"],
    require => Apt::Ppa['ppa:wine/wine-builds'],
  }
}
