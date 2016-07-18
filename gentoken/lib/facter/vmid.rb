Facter.add(:vmid) do
  setcode do
    Facter::Core::Execution.exec("echo $(dmidecode -t 4 | grep ID | sed 's/.*ID://;s/ //g') $(ifconfig | grep eth1 | awk '{print $NF}' | sed 's/://g')")
  end
end
