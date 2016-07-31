class phishing::mailserver {
  node "mailserver.phishing.vm" {
    include mailserver
    mailserver::account { "victim":
      password => "victim",
    }
  }
}
