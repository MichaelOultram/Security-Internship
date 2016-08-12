# Metasploit module

This module uses clones metasploit from github and install it. Please note that it can take a while to install metasploit.

## Requirements

- maestrodev-rvm module

## How to use this module

This module only requires a list of users who should be able to use the module.

```puppet
class { 'metasploit':
  location => "/opt",
  users => ["alice", "bob"],
}
```

You can change the install location if desired. By default it uses the `/opt` directory.
