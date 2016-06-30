class wireshark {

	package { 'wireshark':
		ensure => present,
	  	before => File["/home/charlie/wireshark"],
	}

	file { '/home/charlie/wireshark' :
    		ensure => 'link',
    		target => '/usr/bin/wireshark',
  }
}
