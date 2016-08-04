class phishing::baker {
  node "baker.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "j.baker": password => "notoldguy", }

  }
}
