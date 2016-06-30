class protocols { 

define puppet::binary::symlink ($binary = $title) {
  file {"${binary}":
    path => "/tmp/${binary}.java",
    content => template("protocols/${binary}.java.erb"),
    #target => "/opt/puppetlabs/bin/${binary}",
    owner => 'root',
    group => 'root',
    mode => '0700',
    before => Exec["compile_server${binary}"]
  }
  exec { "compile_server${binary}":
      command => "rm ${binary}.java",
    path => "usr/bin/:/bin",
    cwd => "/tmp"
  }
}


$binaries = ["Protocol1Server", "Protocol2Server"]

puppet::binary::symlink { $binaries: }
}