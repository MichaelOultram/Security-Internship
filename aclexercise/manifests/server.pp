class aclexercise::server {
  node "server.acl.vm" {
    include sshserver

    # Root account
    $password = "rootpassword"
    user { 'root':
      home => '/root',
      ensure => present,
      shell => '/bin/bash',
      password => generate('/bin/sh', '-c', "openssl passwd -1 ${password} | tr -d '\n'"),
    }
    file { "/root/token":
      owner => "root",
      group => "root",
      mode => "0400",
      content => join(["Token for exercise 2.1\n", gentoken("ex21"), "\n"]),
    }

    # Crackable Accounts
    $non_token_accounts = ["001:wonders", "004:ORION", "005:computerscience", "006:Eeknay", "007:Love2", "008:mail", "009:noom", "010:tested", "011:dwssap", "012:windows95", "014:natalie1980", "015:llabtooF", "016:JEDIS", "017:SKATER1", "020:Fiona6", "021:niemteL", "022:Rekcah", "024:chocolatE", "025:1love", "027:kinggnik", "028:louis15", "030:marshalls", "031:bonzo", "032:imissyou2", "033:p1casso", "034:Ocsid", "035:tennisplayer", "036:iverpool", "037:mirrormirror", "038:london2012", "039:batmanrobin", "040:1loveyou", "041:tbone", "042:piano88", "043:terceS", "044:star69", "045:3trinity", "046:hunters", "047:marks", "048:demon1$", "049:gratefuldead", "050:123456", "051:Maverick1", "052:eptember", "053:vernon1", "054:nintendo64", "055:psswd", "056:VOLCANOES", "058:chrsbrwn", "059:pnkflyd", "060:passing", "061:7lucky", "062:4mother", "063:WINDOWS8", "065:crackerjack", "066:assword", "067:schooling", "068:england66", "070:flashforward", "071:Tset", "072:summerholiday", "073:flanders1", "075:HalloHallo", "076:pa55word", "077:beckham1", "078:xmen", "079:kittens", "080:parrots", "081:cameron", "083:kellyclarkson", "084:4charity", "085:JACKSON5", "086:nursed", "087:Rocket4", "088:l1nk1npark", "091:radarlove", "092:openup!", "093:drowssaP", "094:2lonely", "095:HELP", "096:snipers", "097:2cool", "098:magiccigam", "099:password", "100:spiritradio", "101:nomel", "102:JohnJohn", "104:chris86", "105:buttercuP", "107:2cows", "108:clrksn", "109:guesttseug", "111:sean1978", "112:tommot", "113:bismillah", "115:ideJ", "117:BULLDOG", "118:december25", "119:qwertyqwerty", "120:SCORPION1", "122:apollo14", "124:ocean11", "125:terces", "126:monkeys!", "127:sirhc", "128:FOOTBALL", "129:kertratS", "131:mark", "134:uperstar", "136:swoosh", "138:Niaps", "139:HOTMAIL1", "140:ytrewq", "141:safetydance", "142:HACKER!", "143:dailydaily", "144:Diamond9", "146:alien", "148:4Summer", "149:ELECTRIC6", "150:opus", "151:Cheerleader3", "152:gretel", "153:truelove.", "154:amazing1!", "155:warri0r", "156:WOLVERINE", "157:smiling", "158:Terminal5", "159:Beyonce8", "160:what?", "161:imple", "162:rsenal", "163:asdflkj", "164:hahahahahaha", "165:gnilrets", "167:pentiuM", "168:1hope", "171:researchstudent", "172:JOEY1", "173:4christmas", "174:ZOMBIES", "175:Superfly2"]
    $token_accounts = ["013:Thunderbird5", "133:broadway", "145:atabase"]
    group { "staff":
  		ensure => "present",
  		before => [Crackableuser[$non_token_accounts], Crackableuser[$token_accounts]],
  	}
    crackableuser { $non_token_accounts: }
    crackableuser { $token_accounts:
      token => true,
    }

    # ssh private key backup
    $folders = ["/backup", "/backup/charlie", "/backup/charlie/.ssh"]
    file { $folders:
      ensure => "directory",
    }
    file { '/backup/charlie/.ssh/id_rsa.pub':
      content => $aclexercise::nodes::charlie_keys[0],
      require => File[$folders],
    }
    file { '/backup/charlie/.ssh/id_rsa':
      content => $aclexercise::nodes::charlie_keys[1],
      require => File[$folders],
    }
    file { '/backup/charlie/.ssh/authorized_keys':
      content => $aclexercise::nodes::charlie_keys[0],
      require => File[$folders],
    }
  }
}

# TODO: Use MD5 so passwords are actually crackable
define crackableuser($token = false) {
  $username = split($name, ":")[0]
  $password = split($name, ":")[1]

  user { $username:
    home => "/home/${username}",
    gid => "staff",
    ensure => present,
    managehome => $token,
    shell => '/bin/bash',
    password => generate('/bin/sh', '-c', "openssl passwd -1 ${password} | tr -d '\n'"),
  }

  if $token {
    file { "/home/${username}/token":
      owner => $username,
      group => "staff",
      mode => "0400",
      content => join(["Token for exercise 2-$username\n", gentoken("ex2-${username}"), "\n"]),
    }
  }

}
