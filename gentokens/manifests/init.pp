class gentoken {
  $packages = ["openssl", "ruby"]
  package { $packages:
    ensure => "installed",
  }
}
