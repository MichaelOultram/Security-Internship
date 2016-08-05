class phishing::lord {
  node "lord.worklink.vm" {
    require java

    # Create User Account
    genuser { "s.lord": password => "newbie", }

    # Copy and Compile MailReader for s.lord
    file { "/home/s.lord/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "s.lord",
      require => Genuser['s.lord'],
    }
    file { "/home/s.lord/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 's.lord', 'pass' => 'newbie'}),
      owner => "s.lord",
      require => Genuser['s.lord'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/s.lord",
      require => [File['/home/s.lord/mail.jar'], File["/home/s.lord/MailReader.java"]],
    }

    # Run MailReader as s.lord when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/s.lord\nsu s.lord -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
