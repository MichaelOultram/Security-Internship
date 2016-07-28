class sshserver {
  class { 'ssh::server':
    storeconfigs_enabled => false,
    options => {
      'X11Forwarding'          => 'yes',
      'PasswordAuthentication' => 'yes',
      'PermitRootLogin'        => 'yes',
      'Port'                   => [22],
    },
  }-> # Generate rsa host key
  exec { "ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa":
    provider => "shell",
    cwd => "/",
  }-> # Start ssh server when container starts
  file { "/etc/my_init.d/ssh_server.sh":
    content => "#!/bin/bash\nservice ssh start\n",
    mode => "0777",
  }
}
