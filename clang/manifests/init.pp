class clang {
  exec { "apt-update":
    command => 'apt-get update',
    provider => "shell",
    before => Package['clang'],
  }

  package { 'clang':
    ensure => installed,
  }
}
