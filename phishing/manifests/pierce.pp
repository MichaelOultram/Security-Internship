class phishing::pierce {
  node "pierce.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "p.pierce": password => "oldguy", }

  }
}
