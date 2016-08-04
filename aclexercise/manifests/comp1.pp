class aclexercise::comp1 {
  node "comp1.acl.vm" {
    include sshserver

    # Comp1 has a "desktop"
    package { 'xorg':
      ensure => installed,
    }

    genuser { 'alice': password => "al1c3", }
    genuser { 'bob': password => "b0bBy", }

    file { "/home/bob":
      ensure => directory,
      mode => "777",
    }->
    file { "/home/bob/token":
      owner => "bob",
      group => "bob",
      mode => "0400",
      content => join(["Token for exercise 2.5\n", gentoken("ex25"), "\n"]),
    }
  }
}
