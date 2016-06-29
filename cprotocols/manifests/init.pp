class cprotocols {
  require clang

  file { 'copy_source':
    path => '/tmp/Protocol1Server.cpp',
    source => 'puppet:///modules/cprotocols/Protocol1Server.cpp',
    owner => 'root',
    group => 'root',
    mode => '0700',
    before => Exec['compile_server']
  }

  exec { "compile_server":
    command => 'clang++ Protocol1Server.cpp -o Protocol1Server &&
                mv Protocol1Server /root/Protocol1Server &&
                rm Protocol1Server.cpp',
    path => '/usr/bin/:/bin',
    cwd => '/tmp',
  }

}
