class phishing::victimpc {
  node "victimpc.phishing.vm" {
    require java

    # Create Victim Account
    group { "victim":
      ensure => "present",
      before => User["victim"],
    }
    user { 'victim':
      ensure   => 'present',
      home     => '/home/victim',
      groups   => "victim",
      password => '$1$AS8jt.x2$er9sp1Bi8axWTEQnVK4Gg/',
      password_max_age => '99999',
      password_min_age => '0',
      shell    => '/bin/bash',
      gid      => '001',
      uid	 => '505',
    }
    file { "victim_home":
      path    => "/home/victim",
      owner   => "victim",
      ensure  => directory,
      require => User['victim'],
    }

    # Copy and Compile MailReader for victim
    $email_server = "phishing.vm"
    $email_user = "victim"
    $email_pass = "victim"
    file { "/home/victim/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "victim",
      require => File['victim_home'],
    }
    file { "/home/victim/MailReader.java":
      content => template("phishing/MailReader.java.erb"),
      owner => "victim",
      require => File['victim_home'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/victim",
      require => [File['/home/victim/mail.jar'], File["/home/victim/MailReader.java"]],
    }

    # Run MailReader as victim when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/victim\nsu victim -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }
  }
}
