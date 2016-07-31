class aclexercise::nodes ($ip_start = "172.18.0") {
  $charlie_keys = gen_rsa_pair("acl_charlie")

  class { 'aclexercise::gateway':
    ip_start => $ip_start,
  }
  class { 'aclexercise::server':
    charlie_keys => $charlie_keys,
  }

  class { 'aclexercise::comp1':

  }

  class { 'aclexercise::comp2':
    charlie_keys => $charlie_keys,
  }

}
