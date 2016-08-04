class phishing::chothia {
  node "chothia.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "t.chothia": password => "99monkeys", }

  }
}
