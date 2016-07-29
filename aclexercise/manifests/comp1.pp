class aclexercise::comp1{
  node "comp1.acl.vm" {
    include sshserver

    # Comp1 has a "desktop"
    package { 'xorg':
      ensure => installed,
    }
  }
}
