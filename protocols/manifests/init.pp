class protocols { 
require java

#FACTER_protocols="Protocol1Server","Protocol2Server","Protocol3Server" puppet agent --test

define puppet::binary::symlink ($protocol = $title) {
	$token = gentoken("ex1${protocol}")
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
		mv ${protocol}.class /root/${protocol}.class",
		path => '/usr/bin/:/bin',
		cwd => '/tmp',
	  }
	}
}
$protocolsArray = split($::protocols, '[,]')
puppet::binary::symlink { $protocolsArray: }
}

