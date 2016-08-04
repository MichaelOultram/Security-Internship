
class ctf_buffer_overflow {

	include clang
	include ida
	include jdgui

	#Copy the buffer overflow exercises to dan's home and mistery's home
	#Contains both the easy and hard exercise

	$bufferSize = randNumber()
	$tokenOverflow1 = gentoken(join(["ex54", "-", $bufferSize, "-"]))
	$tokenOverflow2 = gentoken("ex55")

	file { "buffer_overflow_easy":
		path => "/home/dan/nameCheck.c",
		content => template("ctf_buffer_overflow/nameCheck.c.erb"),
	      	owner => "dan",
	 	group => "dan",
      		mode => "0700",
		before => Exec["compile_overflow_easy"],
		require => File['/home/dan/'],
	}

	file { "buffer_overflow_hard":
		path => "/home/dan/nameCheckHard.c",
		content => template("ctf_buffer_overflow/nameCheckHard.c.erb"),
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
		content => template("ctf_buffer_overflow/overflowToken1.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow_easy"],
		require => File['/home/dan/'],
	}

	file { "token_buffer_overflow_hard":
		path => "/home/dan/overflowToken2.txt",
		content => template("ctf_buffer_overflow/overflowToken2.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_overflow_hard"],
		require => File['/home/dan/'],
	}

	# Create Dan Account
	group { "dan":
		ensure => "present",
		before => User["dan"],
	}
	user { 'dan':
		ensure   => 'present',
		home     => '/home/dan',
		groups   => "dan",
		password => '$1$xyz$GuUjxxPDncQ3w26IlSFn10',
		password_max_age => '99999',
    		password_min_age => '0',
		shell    => '/bin/bash',
		gid      => '001',
		uid	 => '506',
	}
	file { "dan_home":
		path    => "/home/dan",
		owner   => "dan",
		ensure  => directory,
		require => User['dan'],
	}

	# Create mistery Account
	group { "mistery":
		ensure => "present",
		before => User["mistery"],
	}
	user { 'mistery':
		ensure   => 'present',
		home     => '/home/mistery',
		groups   => "mistery",
		password => '$1$VIqB1s2z$pDVEY8hqqjfgtCESmmteA.', #mistery
		password_max_age => '99999',
    		password_min_age => '0',
		shell    => '/bin/bash',
		gid      => '001',
		uid	 => '507',
	}
	file { "mistery_home":
		path    => "/home/mistery",
		owner   => "mistery",
		ensure  => directory,
		require => User['mistery'],
	}
}
