class phishing::pierce {
  node "pierce.worklink.vm" {
    require java

    $packages = ["libreoffice", "xvfb"]
    package { $packages:
      ensure => installed,
    }

    # Create User Account
    genuser { "m.pierce": password => "oldguy", }

    # Copy and Compile MailReader for m.pierce
    file { "/home/m.pierce/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "m.pierce",
      require => Genuser['m.pierce'],
    }
    file { "/home/m.pierce/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 'm.pierce', 'pass' => 'oldguy'}),
      owner => "m.pierce",
      require => Genuser['m.pierce'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/m.pierce",
      require => [File['/home/m.pierce/mail.jar'], File["/home/m.pierce/MailReader.java"]],
    }

    # Run MailReader as m.pierce when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/m.pierce\nsu m.pierce -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
