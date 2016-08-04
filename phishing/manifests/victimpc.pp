class phishing::victimpc {
  node "victimpc.worklink.vm" {
    require java
    include sshserver

    /*package { 'xorg':
      ensure => installed,
    }

    class { "adobereader":
      user => "hacker",
    }*/

    # Create Victim Account
    genuser { "victim": password => "mITc!v", }

    # Copy and Compile MailReader for victim
    file { "/home/victim/mail.jar":
      source => "puppet:///modules/phishing/mail.jar",
      owner => "victim",
      require => Genuser['victim'],
    }
    file { "/home/victim/MailReader.java":
      content => epp("phishing/MailReader.java.epp", {'server' => "${phishing::nodes::ip_start}.23", 'user' => 'victim', 'pass' => 'mITc!v'}),
      owner => "victim",
      require => Genuser['victim'],
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
