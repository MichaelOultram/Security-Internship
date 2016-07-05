class reverse {
	include clang

	$password = genString() # Set the random string in here! with ruby 
	$tokenReverse = gentoken($reverse) # Set as a facter FACTER_reverse="ex51" puppet agent --test

	# Compile and move code to dan's folder and mistery folder
	file { "reverse_engineer":
		path => "/home/dan/RE.cpp",
		content => template("reverse/RE.cpp.erb"),
	      	owner => "dan",
	 	group => "dan",
      		mode => "0700",
		before => Exec["compile_engineering"],
		require => File['/home/dan/'],
	}

	file { '/home/mistery/reverseEngineering':
		ensure => present,
		source => "/home/dan/reverseEngineering",
		require => Exec['compile_engineering'],

	}

	exec { "compile_engineering":
		command => "clang++ -std=c++11 -Werror -o reverseEngineering RE.cpp &&
		rm RE.cpp && chown mistery:mistery reverseEngineering && chmod +s reverseEngineering",
		path => '/usr/bin/:/bin',
		cwd => '/home/dan/',
		require => File['/home/dan/'],
	}

	# Move token in a file that cannot be read by user dan
	file { "token_reverse_engineer":
		path => "/home/dan/tokenRE.txt",
		content => template("reverse/tokenRE.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_engineering"],
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
		password => '$1$xyz$GuUjxxPDncQ3w26IlSFn10',
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
