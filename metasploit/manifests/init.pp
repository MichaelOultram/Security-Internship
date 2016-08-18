class metasploit($location = "/opt", $users = []) {
  # Install Ruby 2.3.1 and Bundler
  include rvm
  rvm_system_ruby { 'ruby-2.3.1':
    ensure      => 'present',
    default_use => true,
  }

  # Install required packages for metasploit
  $packages = ["nmap", "build-essential", "libreadline-dev", "libssl-dev", "libpq5", "libpq-dev", "libreadline5", "libsqlite3-dev", "libpcap-dev", "openjdk-7-jre", "git-core", "autoconf", "postgresql", "pgadmin3", "zlib1g-dev", "libxml2-dev", "libxslt1-dev", "vncviewer", "libyaml-dev"]
  package { $packages:
    ensure => installed,
  }->

  # Install metasploit
  exec { "clone_metasploit":
    command => "git clone https://github.com/rapid7/metasploit-framework.git metasploit",
    provider => "shell",
    creates => "${location}/metasploit",
    cwd => $location,
  }->
  exec { "bundle":
    command => '/bin/bash --login -c "rvm @global do gem install bundle && rvm @global do bundle install"',
    path =>'/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-2.3.1/bin:/usr/bin/:/bin:/usr/local/bin',
    cwd =>"${location}/metasploit",
    require => Rvm_system_ruby['ruby-2.3.1'],
  }->
  file_line { "/etc/profile":
    path => "/etc/profile",
    line => "export PATH=\$PATH:/opt/metasploit",
  }

  # Make sure all users are in the rvm group
  user { $users:
    groups => ['rvm'],
  }
}
