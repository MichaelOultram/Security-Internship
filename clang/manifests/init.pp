class clang {
  exec { "apt-update":
    command => 'sudo apt-get update',
    path => '/usr/bin/:/bin',
    before => Package['clang']
  }

  package { 'clang':
    ensure => installed,
  }
}
