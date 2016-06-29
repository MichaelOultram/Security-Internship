
class protocols {
  require java

  $token = "TOKEN_HERE"

  file { 'copy_source':
    path => '/tmp/Protocol1Server.java',
    content => template('protocols/Protocol1Server.java.erb'),
    owner => 'root',
    group => 'root',
    mode => '0700',
    before => Exec['compile_server']
  }

  exec { "compile_server":
    command => 'javac Protocol1Server.java &&
                mv Protocol1Server.class /root/Protocol1Server.class &&
                rm Protocol1Server.java',
    path => '/usr/bin/:/bin',
    cwd => '/tmp',
  }

}
