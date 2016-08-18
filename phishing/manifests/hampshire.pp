class phishing::hampshire {
  node "hampshire.worklink.vm" {
    require java

    $packages = ["libreoffice", "xvfb"]
    package { $packages:
      ensure => installed,
    }

    # Create User Account
    genuser { "c.hampshire": password => "jobgiver", }

    # Copy and Compile MailReader for c.hampshire
    file { "/home/c.hampshire/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "c.hampshire",
      require => Genuser['c.hampshire'],
    }
    file { "/home/c.hampshire/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 'c.hampshire', 'pass' => 'jobgiver'}),
      owner => "c.hampshire",
      require => Genuser['c.hampshire'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/c.hampshire",
      require => [File['/home/c.hampshire/mail.jar'], File["/home/c.hampshire/MailReader.java"]],
    }

    # Run MailReader as c.hampshire when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/c.hampshire\nsu c.hampshire -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
