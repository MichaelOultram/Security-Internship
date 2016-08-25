class phishing::baker {
  node "baker.worklink.vm" {
    require java

    # Create User Account
    genuser { "j.baker": password => "notoldguy", }

    # Copy and Compile MailReader for j.baker
    file { "/home/j.baker/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "j.baker",
      require => Genuser['j.baker'],
    }
    file { "/home/j.baker/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 'j.baker', 'pass' => 'notoldguy'}),
      owner => "j.baker",
      require => Genuser['j.baker'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/j.baker",
      require => [File['/home/j.baker/mail.jar'], File["/home/j.baker/MailReader.java"]],
    }

    # Run MailReader as j.baker when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/j.baker\nsu j.baker -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
