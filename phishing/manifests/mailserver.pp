class phishing::mailserver {
  node "mailserver.worklink.vm" {
    include mailserver
    genuser { "victim": password => "victim", }
  }
}
