class gentoken ($vmid) {
  $packages = ["openssl", "ruby"]
  package { $packages:
    ensure => "installed",
  }

  file { '/root/vmid':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => $vmid,
  }
}
