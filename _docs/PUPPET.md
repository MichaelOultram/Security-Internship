# Puppet Tips and Ticks

If you are reading this document last, you will have noticed I have been saying puppet _installs_ things. This is a bit of a white lie as the whole idea of puppet is that you define _what_ a system should be and not _how_ to configure it. For instance if we want the nmap package to be installed we could write:

```puppet
node 'puppet' {
  package { 'nmap':
    ensure => installed,
  }
}
```

This does specify how nmap should be installed. If we were using a debian based operating system then puppet would run the command `sudo apt-get install -y nmap`. But if we were using fedora then puppet would use `sudo yum install -y nmap`. If nmap was already installed however, then puppet wouldn't need to do anything. The purpose of _what_ instead of _how_ is so that the same puppet code can be run different operating systems and can also be run as often as possible. By default, puppet will automatically run `puppet agent --test` every 30 minutes (which can be irritating when you are in the middle of writing a module and puppet tries to run it).
