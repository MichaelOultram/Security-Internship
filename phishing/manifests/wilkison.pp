class phishing::wilkison {
  node "wilkison.worklink.vm" {
    require java

    # Create User Account
    genuser { "j.wilkison": password => "computerscience", }

    # Copy and Compile MailReader for j.wilkison
    file { "/home/j.wilkison/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "j.wilkison",
      require => Genuser['j.wilkison'],
    }
    file { "/home/j.wilkison/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 'j.wilkison', 'pass' => 'oldguy'}),
      owner => "j.wilkison",
      require => Genuser['j.wilkison'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/j.wilkison",
      require => [File['/home/j.wilkison/mail.jar'], File["/home/j.wilkison/MailReader.java"]],
    }

    # Run MailReader as j.wilkison when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/j.wilkison\nsu j.wilkison -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
