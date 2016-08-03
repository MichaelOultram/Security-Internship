class wine {
  include apt

  exec { 'dpkg --add-architecture i386':
    provider => "shell",
  }->
  apt::ppa { 'ppa:wine/wine-builds': }->
  apt::source { 'ubuntu_xenial_multiverse':
    location => 'http://archive.ubuntu.com/ubuntu/',
    release  => 'xenial',
    repos    => 'multiverse',
  }->
  apt::source { 'ubuntu_xenial_updates_multiverse':
    location => 'http://archive.ubuntu.com/ubuntu/',
    release  => 'xenial-updates',
    repos    => 'multiverse',
  }->
  exec { 'apt-get update':
    provider => "shell",
  }->
  package { 'xvfb':
    ensure => installed,
  }->
  package { 'winehq-devel':
    ensure => installed,
    install_options => ["--install-recommends"],
  }->
  package { 'wine-mono':
    ensure => installed,
  }->
  package { 'wine-gecko':
    ensure => installed,
  }->
  exec { 'WINEDLLOVERRIDES="mscoree,mshtml=" wineboot -u':
    provider => "shell",
    cwd => "/root",
  }
}
