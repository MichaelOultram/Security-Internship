class ctf_reverse_engineering {

	require java
	include clang
	include jdgui
	include ida

	# -------------------REVERSE ENGINEERING WITH C++----------------------#
	# ---------------------------------------------------------------------#

	$password = genString() # Set the random string in here! with ruby
	$tokenReverse = gentoken("ex53")

	# Compile and move code to dan's folder and mistery folder
	file { "reverse_engineer":
		path => "/home/dan/RE.cpp",
		content => template("ctf_reverse_engineering/RE.cpp.erb"),
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
		content => template("ctf_reverse_engineering/tokenRE.txt.erb"),
	      	owner => "mistery",
	 	group => "mistery",
      		mode => "0700",
		before => Exec["compile_engineering"],
		require => File['/home/dan/'],
	}
	# ----------------------REVERSE ENGINEERING JAVA ----------------------#
	# ---------------------------------------------------------------------#

	# Copy the exercise1.jar file into user dan's folder
	file { '/home/dan/exercise1.jar':
		ensure => present,
		source => "puppet:///modules/ctf_reverse_engineering/exercise1.jar/",
	}

	# Copy the exercise2.jar file into user dan's folder
	file { '/home/dan/exercise2.jar':
		ensure => present,
		source => "puppet:///modules/ctf_reverse_engineering/exercise2.jar/",
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
