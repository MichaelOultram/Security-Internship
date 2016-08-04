class phishing::hampshire {
  node "hampshire.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "c.hampshire": password => "jobgiver", }

  }
}
