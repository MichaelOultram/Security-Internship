class metasploit(){
  include rvm


  /*exec { "update":
		command => "apt-get update",
		path => '/usr/bin/:/bin',
	}->

  exec { "upgrade":
		command => "apt-get upgrade -y",
		path => '/usr/bin/:/bin',
	}->*/

  rvm_system_ruby { 'ruby-2.3.1':
    ensure      => 'present',
    default_use => true,
  }

  rvm_gem { 'bundler':
    name         => 'bundle',
    ruby_version => 'ruby-2.3.1',
    ensure       => latest,
    require      => Rvm_system_ruby['ruby-2.3.1'];
  }

  #$packages = ["nmap", "build-essential", "libreadline-dev", "libssl-dev", "libpq5", "libpq-dev", "libreadline5", "libsqlite3-dev", "libpcap-dev", "openjdk-7-jre", "git-core", "autoconf", "postgresql", "pgadmin3", "curl", "zlib1g-dev", "libxml2-dev", "libxslt1-dev", "vncviewer", "libyaml-dev"]
  $packages = ["nmap", "build-essential", "libreadline-dev", "libssl-dev", "libpq5", "libpq-dev", "libreadline5", "libsqlite3-dev", "libpcap-dev", "openjdk-7-jre", "git-core", "autoconf", "postgresql", "pgadmin3", "zlib1g-dev", "libxml2-dev", "libxslt1-dev", "vncviewer", "libyaml-dev"]
  package { $packages:
    ensure => installed,
  }->

  exec {"clone_metasploit":
    command => "git clone https://github.com/rapid7/metasploit-framework.git",
    provider => "shell",
    creates => "/opt/metasploit-framework",
    cwd =>'/opt',
  }->

  exec {"chage_owner":
    command => "chown -R root /opt/metasploit-framework",
    path =>'usr/bin/:/bin',
  }->

  /*package { 'bundle':
    provider => "gem",
    ensure => installed,
  }->*/

  exec {"bundle":
    command => '/bin/bash --login -c "gem install bundle && bundle install"',
    path =>'/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-2.3.1/bin:/usr/bin/:/bin:/usr/local/bin',
    cwd =>'/opt/metasploit-framework',
    require => Rvm_gem['bundler'], #Rvm_system_ruby['ruby-2.3.1'],
  }

}
