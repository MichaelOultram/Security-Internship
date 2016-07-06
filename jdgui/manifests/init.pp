
class jdgui {

	exec{'retrieve_jdgui':
		command => "/usr/bin/wget -q https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui-1.4.0.jar -O /home/dan/tools/jd-gui-1.4.0.jar",
		creates => "/home/dan/tools/jd-gui-1.4.0.jar",
		require => File['/home/dan/tools/']
	}

	file{'/home/dan/tools/jd-gui-1.4.0.jar':
		mode => 0755,
		require => Exec["retrieve_jdgui"],
	}

	file { "tools_dan":
		path    => "/home/dan/tools",
		owner   => "dan",
		ensure  => directory,
		require => User['dan'],
		before => Exec["retrieve_jdgui"],
	}

}
