class protocols ($protocols) { 

# one-off defined resource type, in
# /etc/puppetlabs/code/environments/production/modules/puppet/manifests/binary/symlink.pp
define puppet::binary::symlink ($protocol = $title) {
  file {"${protocol}":
    path => "/tmp/${protocol}.java",
    content => template("protocols/${protocol}.java.erb"),
    #target => "/opt/puppetlabs/bin/${binary}",
    owner => 'root',
    group => 'root',
    mode => '0700',
    before => Exec["compile_server${protocol}"]
  }
  exec { "compile_server${protocol}":
	command => "javac ${protocol}.java &&
	mv ${protocol}.class /root/${protocol}.class &&
	rm ${protocol}.java",
        path => '/usr/bin/:/bin',
	cwd => '/tmp',
  }
}

# using defined type for iteration, somewhere else in your manifests
#$protocols = ["Protocol1Server", "Protocol2Server"]

puppet::binary::symlink { $protocols: }
}

