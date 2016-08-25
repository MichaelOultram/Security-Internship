class phishing::chothia {
  node "chothia.worklink.vm" {
    require java

    # Create User Account
    genuser { "t.chothia": password => "99monkeys", }

    # Copy and Compile MailReader for t.chothia
    file { "/home/t.chothia/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "t.chothia",
      require => Genuser['t.chothia'],
    }
    file { "/home/t.chothia/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.22", 'user' => 't.chothia', 'pass' => '99monkeys'}),
      owner => "t.chothia",
      require => Genuser['t.chothia'],
    }
    exec { 'compile MailReader':
      command => 'javac -cp mail.jar MailReader.java',
      provider => "shell",
      cwd => "/home/t.chothia",
      require => [File['/home/t.chothia/mail.jar'], File["/home/t.chothia/MailReader.java"]],
    }

    # Run MailReader as t.chothia when container starts
    file { "startmailreader":
      path => "/etc/my_init.d/mailreader.sh",
      content => "#!/bin/bash\ncd /home/t.chothia\nsu t.chothia -c \"java -cp mail.jar:. MailReader &\"\n",
      mode => '0700',
    }

  }
}
