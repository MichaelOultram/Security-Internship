# Probably not needed
class gentoken {
  $packages = ["openssl", "ruby"]
  package { $packages:
    ensure => "installed",
  }
}
