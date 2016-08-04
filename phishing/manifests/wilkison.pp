class phishing::wilkison {
  node "wilkison.worklink.vm" {
    include sshserver

    # Create User Account
    genuser { "j.wilkison": password => "computerscience", }

  }
}
