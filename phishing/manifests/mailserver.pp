class phishing::mailserver {
  node "mailserver.worklink.vm" {
    class { "mailserver":
      hostname => "worklink.vm",
    }
    genuser { "victim": password => "victim", has_login => false,}
  }
}
