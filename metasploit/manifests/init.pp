class metasploit(){

  exec { "update":
		command => "sudo apt-get update",
		path => '/usr/bin/:/bin',
	}->

  exec { "upgrade":
		command => "sudo apt-get upgrade",
		path => '/usr/bin/:/bin',
	}->

  exec {"packages"
    command => "sudo apt-get install nmap build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev openjdk-7-jre git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev",
    path =>'/usr/bin/:/bin'
  }->

  exec {"clone_metasploit"
    command => "sudo git clone https://github.com/rapid7/metasploit-framework.git"
    path =>'usr/bin/:/bin'
    cwd =>'/opt'
  }->

  exec {"chage_owner"
    command => "sudo chown -R `whoami` /opt/metasploit-framework"
    path =>'usr/bin/:/bin'
  }->

  exec {"bundle"
    command => "bundle install"
    path =>'usr/bin/:/bin'
    cwd =>'/opt/metasploit-framework'
  }

}
