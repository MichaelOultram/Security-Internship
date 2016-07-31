define mailserver::account ($username = $name, $password, $has_login = false) {
  user { $username:
    ensure => present,
    shell => $has_login ? {
      true => '/bin/bash',
      false => '/bin/false',
    },
    password => generate('/bin/sh', '-c', "openssl passwd -1 ${password} | tr -d '\n'"),
  }->
  file { "/home/${username}":
    ensure => directory,
    owner => $username,
    mode => "700",
  }
}
