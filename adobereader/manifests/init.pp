class adobereader {
  include wine

  file { '/root/Adobe_Reader_8.0.exe':
    source => "puppet:///modules/adobereader/Adobe_Reader_8.0.exe",
    require => Package['winehq-devel'],
  }->
  exec { 'install adobe reader':
    command => 'xvfb-run wine Adobe_Reader_8.0.exe /sPB /rs /l /msi"/qb-! /norestart ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"',
    provider => "shell",
    cwd => "/root",
  }
}
