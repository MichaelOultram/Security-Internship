class phishing::lord {
  node "lord.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "s.lord": password => "newbie", }

  }
}
