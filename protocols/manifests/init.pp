class protocols {
	require java
	include wireshark
	include gentoken

	# Create /root/tmp so nobody but root can access it
	file { "/root/tmp":
		ensure => directory,
	}

	# Move the files to the root directory
	file { "EncryptClass.java":
		path => "/root/EncryptClass.java",
		source => "puppet:///modules/protocols/loader/EncryptClass.java/",
		before => Exec['compile_class'],
	}

	exec { "compile_class":
		command => "javac EncryptClass.java",
		path => '/usr/bin/:/bin',
		cwd => '/root/',
		require => File['/root/EncryptClass.java'],
	}
		
	file { "RunProtocol.java":
		path => "/root/RunProtocol.java",
		source => "puppet:///modules/protocols/loader/RunProtocol.java/",
		before => Exec["compile_runProtocol"],
	}

	exec { "compile_runProtocol":
		command => "javac RunProtocol.java && rm RunProtocol.java",
		path => '/usr/bin/:/bin',
		cwd => '/root/',
		require => File['/root/RunProtocol.java'],
	}
	

	# Command to run:
	#FACTER_protocols="Protocol1","Protocol2","Protocol3","Protocol4" puppet agent --test

  # Installs all protocols
	define puppet::binary::symlink ($protocol = $title) {
		$token = gentoken("${protocol}")

		if("${protocol}" != '') {
			# Copy version with token
		  file {"${protocol}_token":
		    path => "/root/tmp/${protocol}.java",
		    content => template("protocols/${protocol}.java.erb"),
		    owner => 'root',
		    group => 'root',
		    mode => '0700',
		    before => Exec["${protocol}_compile"],
				require => File['/root/tmp'],
		  }

			# Compile Server and remove source code
	  	exec { "${protocol}_compile":
				command => "javac ${protocol}.java &&
				mv ${protocol}.class /root/${protocol}.class",
				#rm /root/tmp/${protocol}.java",
				path => '/usr/bin/:/bin',
				cwd => '/root/tmp',
				require => File['/root/tmp'],
				before => Exec["compile_encryption_${protocol}"],
		  }

		exec {"compile_encryption_${protocol}":
				command => "java EncryptClass ${protocol}.class",
				path => '/usr/bin/:/bin',
				cwd => '/root/',
				require => File['/root/EncryptClass.java']
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

      # Creates every protocol start
      exec { "${protocol}_start":
        command => "echo 'java RunProtocol ${protocol}.class &' >> startprotocol",
        path => '/usr/bin/:/bin',
        cwd => '/etc/init.d',
        require => File["startprotocol"],
      }
		}
	}

  # Starts every protocols on start of VM
  file {"startprotocol":
  	path => "/etc/init.d/startprotocol",
  	content => template("protocols/startprotocol.erb"),
  	owner => root,
  	group => root,
  	mode => '0700',
  }

	# Setup all protocol servers
	$protocolsArray = split($::protocols, '[,]')
	puppet::binary::symlink { $protocolsArray:
			require => File['charlie_home'],
		}

	# Removed encryption class
	exec { "remove_encrypt":
		command => "rm Encrypt*",
		path => '/usr/bin/:/bin',
		cwd => '/root/',
		require => puppet::binary::symlink[$protocolsArray],
	}

	# Create Charlie Account
	group { "charlie":
		ensure => "present",
		before => User["charlie"],
	}
	user { 'charlie':
		ensure   => 'present',
		home     => '/home/charlie',
		groups   => "charlie",
		password => '$1$AS8jt.x2$er9sp1Bi8axWTEQnVK4Gg/',
		password_max_age => '99999',
    password_min_age => '0',
		shell    => '/bin/bash',
		gid      => '001',
		uid	 => '505',
	}
	file { "charlie_home":
		path    => "/home/charlie",
		owner   => "charlie",
		ensure  => directory,
		require => User['charlie'],
	}
}
