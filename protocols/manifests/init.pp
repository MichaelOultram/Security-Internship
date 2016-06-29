class protocols { 

# one-off defined resource type, in
# /etc/puppetlabs/code/environments/production/modules/puppet/manifests/binary/symlink.pp
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
	command => "javac ${binary}.java &&
	mv ${binary}.class /root/${binary}.class &&
	rm ${binary}.java",
        path => '/usr/bin/:/bin',
	cwd => '/tmp',
  }
}

# using defined type for iteration, somewhere else in your manifests
$binaries = ["Protocol1Server", "Protocol2Server"]

puppet::binary::symlink { $binaries: }
}

