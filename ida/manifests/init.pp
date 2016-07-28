class ida {

	exec{'retrieve_ida':
		command => "/usr/bin/wget -q https://out7.hex-rays.com/files/idademo69_linux.tgz -O /home/dan/tools/idademo69_linux.tgz",
		creates => "/home/dan/tools/idademo69_linux.tgz",
		require => File['/home/dan/tools/']
	}
	
	file{'/home/dan/tools/idademo69_linux.tgz':
		mode => 0755,
		require => Exec["retrieve_ida"],
		before => Exec["unpack_tgz"],
	}

	exec{'unpack_tgz':
		command => "/bin/tar -xvzf /home/dan/tools/idademo69_linux.tgz -C /home/dan/tools/ &&
		rm /home/dan/tools/idademo69_linux.tgz",
		creates => "/home/dan/tools/idademo69/",
		require => Exec['retrieve_ida'],
	}
}
