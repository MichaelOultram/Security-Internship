define genuser($username = $name, $password, $gid = $username, $has_home = true, $has_login = true, $groups = []) {
  group { "${username}-${gid}":
    name => $gid,
    ensure => present,
  }

  user { $username:
    home => ($username == root) ? {
      true => "/root",
      false => "/home/${username}",
    },
    gid => $gid,
    ensure => present,
    managehome => $has_home,
    shell => $has_login ? {
      true => '/bin/bash',
      false => '/bin/false',
    },
    password => generate('/bin/sh', '-c', "openssl passwd -1 ${password} | tr -d '\n'"),
    groups => $groups,
    require => Group[$gid],
  }
}
