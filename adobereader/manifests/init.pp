class adobereader($user) {
  require wine

  file { '/root/Adobe_Reader_8.1.2.exe':
    source => "puppet:///modules/adobereader/Adobe_Reader_8.1.2.exe",
  }->
  exec { 'install adobe reader':
    command => 'xvfb-run wine Adobe_Reader_8.1.2.exe /sPB /rs /l /msi"/qb-! /norestart ALLUSERS=2 EULA_ACCEPT=YES SUPPRESS_APP_LAUNCH=YES"',
    provider => "shell",
    cwd => ($user == "root") ? {
        true => "/root",
        false => join(["/home/", $user]),
      },
    user => $user,
    environment => ($user == "root") ? {
        true => "HOME=/root",
        false => join(["HOME=/home/", $user]),
      },
  }
}
