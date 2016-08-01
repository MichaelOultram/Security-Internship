class aclexercise::nodes ($ip_start = "172.18.0") {
  $charlie_keys = gen_rsa_pair("acl_charlie")

  include aclexercise::gateway
  include aclexercise::server
  include aclexercise::comp1
  include aclexercise::comp2

}
