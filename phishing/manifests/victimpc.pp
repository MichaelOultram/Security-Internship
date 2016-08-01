class phishing::victimpc {
  node "victimpc.worklink.vm" {
    require java

    # Create Victim Account
    genuser { "victim": password => "victim", }

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
