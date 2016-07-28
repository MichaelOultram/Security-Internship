
class bufferoverflow {

	include clang
	include ida

	#Copy the buffer overflow exercise to dan's home and mistery's home

	$bufferSize = randNumber()
	$tokenOverflow1 = gentoken("ex52",$bufferSize)
	$tokenOverflow2 = gentoken("ex53",$bufferSize)

	file { "buffer_overflow":
		path => "/home/dan/nameCheck.c",
		content => template("bufferoverflow/nameCheck.c.erb"),
	      	owner => "dan",
	 	group => "dan",
      		mode => "0700",
		before => Exec["compile_overflow"],
		require => File['/home/dan/'],
	}

	exec { "compile_overflow":
		command => "gcc -fno-stack-protector -z execstack -o nameCheck nameCheck.c &&
		chown mistery:mistery nameCheck && chmod +s nameCheck && chmod -wx nameCheck.c",
		path => '/usr/bin/:/bin',
		cwd => '/home/dan/',
		require => File['/home/dan/'],
	}

	file { '/home/mistery/nameCheck':
		ensure => present,
		source => "/home/dan/nameCheck",
		require => Exec['compile_overflow'],
	}

	# Move token in a file that cannot be read by user dan
	file { "token_buffer_overflow1":
		path => "/home/dan/overflowToken1.txt",
		content => template("bufferoverflow/overflowToken1.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow"],
		require => File['/home/dan/'],
	}
	file { "token_buffer_overflow2":
		path => "/home/dan/overflowToken2.txt",
		content => template("bufferoverflow/overflowToken2.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow"],
		require => File['/home/dan/'],
	}
}
