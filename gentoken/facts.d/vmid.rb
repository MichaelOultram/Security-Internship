require 'facter'
Facter.add('vmid') do
  setcode do
    Facter::Core::Execution.exec("sudo echo $(sudo dmidecode -t 4 | grep ID | sed 's/.*ID://;s/ //g') $(ifconfig | grep eth1 | awk '{print $NF}' | sed 's/://g')")
  end
end
