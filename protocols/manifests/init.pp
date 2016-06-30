class protocols { 
require java
$token = "TOKEN"

#FACTER_protocols="Protocol1Server","Protocol2Server","Protocol3Server" puppet agent --test

define puppet::binary::symlink ($protocol = $title) {
if("${protocol}" != '') {
	  file {"${protocol}":
	    path => "/tmp/${protocol}.java",
	    content => template("protocols/${protocol}.java.erb"),
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
}
$protocolsArray = split($::protocols, '[,]')
puppet::binary::symlink { $protocolsArray: }
}

