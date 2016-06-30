Facter.add(:vmid) do
  setcode "sudo echo $(sudo dmidecode -t 4 | grep ID | sed 's/.*ID://;s/ //g') $(ifconfig | grep eth1 | awk '{print $NF}' | sed 's/://g')"
  
end
