
class bufferoverflow {

	include clang
	include ida

	#Copy the buffer overflow exercises to dan's home and mistery's home
	#Contains both the easy and hard exercise

	$bufferSize = randNumber()
	$tokenOverflow1 = gentoken(join(["ex52", "-", $bufferSize, "-"]))
	$tokenOverflow2 = gentoken("ex53")

	file { "buffer_overflow_easy":
		path => "/home/dan/nameCheck.c",
		content => template("bufferoverflow/nameCheck.c.erb"),
	      	owner => "dan",
	 	group => "dan",
      		mode => "0700",
		before => Exec["compile_overflow_easy"],
		require => File['/home/dan/'],
	}

	file { "buffer_overflow_hard":
		path => "/home/dan/nameCheckHard.c",
		content => template("bufferoverflow/nameCheckHard.c.erb"),
	      	owner => "dan",
	 	group => "dan",
      		mode => "0700",
		before => Exec["compile_overflow_hard"],
		require => File['/home/dan/'],
	}

	exec { "compile_overflow_easy":
		command => "gcc -fno-stack-protector -z execstack -o nameCheck nameCheck.c &&
		chown mistery:mistery nameCheck && chmod +s nameCheck && chmod -wx nameCheck.c",
		path => '/usr/bin/:/bin',
		cwd => '/home/dan/',
		require => File['/home/dan/'],
	}

	exec { "compile_overflow_hard":
		command => "gcc -fno-stack-protector -z execstack -o nameCheckHard nameCheckHard.c &&
		chown mistery:mistery nameCheckHard && chmod +s nameCheckHard && chmod -wx nameCheckHard.c",
		path => '/usr/bin/:/bin',
		cwd => '/home/dan/',
		require => File['/home/dan/'],
	}

	file { '/home/mistery/nameCheck':
		ensure => present,
		source => "/home/dan/nameCheck",
		require => Exec['compile_overflow_easy'],
	}

	file { '/home/mistery/nameCheckHard':
		ensure => present,
		source => "/home/dan/nameCheckHard",
		require => Exec['compile_overflow_hard'],
	}

	# Move token in a file that cannot be read by user dan
	file { "token_buffer_overflow_easy":
		path => "/home/dan/overflowToken1.txt",
		content => template("bufferoverflow/overflowToken1.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow_easy"],
		require => File['/home/dan/'],
	}

	file { "token_buffer_overflow_hard":
		path => "/home/dan/overflowToken2.txt",
		content => template("bufferoverflow/overflowToken2.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow_hard"],
		require => File['/home/dan/'],
	}
}
