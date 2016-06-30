class protocols {
	require java

	# Command to run:
	#FACTER_protocols="Protocol1Server","Protocol2Server","Protocol3Server" puppet agent --test

	# Installs all protocols
	define puppet::binary::symlink ($protocol = $title) {
		$token = gentoken("ex1${protocol}")

		if("${protocol}" != '') {
			# Copy version with token
		  file {"${protocol}_token":
		    path => "/tmp/${protocol}.java",
		    content => template("protocols/${protocol}.java.erb"),
		    owner => 'root',
		    group => 'root',
		    mode => '0700',
		    before => Exec["${protocol}_compile"],
		  }

			# Compile Server and remove source code
		  exec { "${protocol}_compile":
				command => "javac ${protocol}.java &&
				mv ${protocol}.class /root/${protocol}.class", # &&
				# rm /root/${protocol}.java
				path => '/usr/bin/:/bin',
				cwd => '/tmp',
		  }

			# Copy version without token
			file { "${protocol}_clean":
				path => "/home/charlie/${protocol}/",
				source => "puppet:///modules/protocols/${protocol}/",
				owner => "charlie",
				group => "charlie",
				mode => "0600",
				recurse => true,
				ensure => directory,
			}
		}
	}

	# Setup all protocol servers
	$protocolsArray = split($::protocols, '[,]')
	puppet::binary::symlink { $protocolsArray:
			require => File['charlie_home'],
		}

	# Create Charlie Account
	group { "charlie_grp":
		ensure => "present",
		before => User["charlie_usr"],
	}
	user { 'charlie_usr':
		ensure   => 'present',
		home     => '/home/charlie',
		groups   => "charlie",
		password => 'charlie99',
		shell    => '/bin/bash',
	}
	file { "charlie_home":
		path    => "/home/charlie",
		owner   => "charlie",
		ensure  => directory,
		require => User['charlie_usr'],
	}
}
