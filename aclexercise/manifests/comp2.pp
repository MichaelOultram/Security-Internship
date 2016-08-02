class aclexercise::comp2 {
  node "comp2.acl.vm" {
    require java
    require clang
    include sshserver

    package { 'xorg': ensure => installed, }
    package { 'python': ensure => installed, }

    # Comp2 users
    genuser { 'alice': password => "al1c3", }
    genuser { 'charlie': password => "charlie99", }
    genuser { 'dan': password => "dan!dan", }
    genuser { 'elvis':
      password => "costello",
      groups => "shadow",
    }

    # Charlie ssh keys
    $folders = ["/home", "/home/charlie", "/home/charlie/.ssh"]
    file { $folders:
      ensure => "directory",
    }
    file { '/home/charlie/.ssh/id_rsa.pub':
      content => $aclexercise::nodes::charlie_keys[0],
      require => File[$folders],
    }
    file { '/home/charlie/.ssh/id_rsa':
      content => $aclexercise::nodes::charlie_keys[1],
      require => File[$folders],
    }

    # Copy alice's directory
    file { "/home/alice":
      ensure => directory,
      source => "puppet:///modules/aclexercise/comp2/alice",
      recurse => true,
      mode => "750",
    }

    # Copy Elvis's directory
    file { "/home/elvis":
      ensure => directory,
      source => "puppet:///modules/aclexercise/comp2/elvis",
      recurse => true,
      mode => "777",
    }->
    exec { 'all_read_write':
      command => 'chmod 766 *',
      provider => "shell",
      cwd => "/home/elvis",
    }->
    exec { 'compile_java':
      command => 'javac EncryptAES.java',
      provider => "shell",
      cwd => "/home/elvis",
    }->
    exec { 'compile_java_c':
      command => 'clang encTimeTestJava.c -o encTimeTestJava',
      provider => "shell",
      cwd => "/home/elvis",
    }->
    exec { 'compile_python_c':
      command => 'clang encTimeTestPython.c -o encTimeTestPython',
      provider => "shell",
      cwd => "/home/elvis",
    }->
    file { "/home/elvis/encTimeTestPython":
      mode => "4751",
    }

    # Tokens
    file { "/home/charlie/token":
      owner => "charlie",
      group => "charlie",
      mode => "0400",
      content => join(["Token for exercise 2.2\n", gentoken("ex22"), "\n"]),
    }
    file { "/home/dan/token":
      owner => "dan",
      group => "dan",
      mode => "0444",
      content => join(["Token for exercise 2.3\n", gentoken("ex23"), "\n"]),
    }
    file { "/home/elvis/token":
      owner => "elvis",
      group => "elvis",
      mode => "0400",
      content => join(["Token for exercise 2.4\n", gentoken("ex24"), "\n"]),
      require => Exec['all_read_write'],
    }
  }
}
