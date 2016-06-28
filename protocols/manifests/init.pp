
class protocols {
  require java

  $token = "TOKEN_HERE"

  file { 'copy_source':
    path => '/root/Protocol1Server.java',
    content => template('protocols/Protocol1Server.java.erb'),
    owner => 'root',
    group => 'root',
    mode => '0700',
  }

  exec { "compile_server":
    command => 'javac Protocol1Server.java',
    path => '/usr/bin/:/bin',
    cwd => '/root',
    require => File["copy_source"],
  }

  exec { 'delete_source':
   command => 'rm Protocol1Server.java',
   path => '/usr/bin/:/bin',
   cwd => '/root',
   require => Exec["compile_server"],
  }

}
