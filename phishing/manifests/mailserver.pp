class phishing::mailserver {
  node "mailserver.worklink.vm" {
    class { "mailserver":
      hostname => "worklink.vm",
    }

    # Admin
    genuser { "t.chothia": password => "99monkeys", }

    # Finance
    genuser { "p.pierce": password => "oldguy", }
    genuser { "j.baker": password => "notoldguy", }

    # Carrers
    genuser { "careers": password => "sreerac", }
    genuser { "c.hampshire": password => "jobgiver", }

    # Interns
    genuser { "j.wilkison": password => "computerscience", }
    genuser { "s.lord": password => "newbie", }
  }
}
