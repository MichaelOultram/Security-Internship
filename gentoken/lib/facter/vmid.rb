Facter.add(:vmid) do
  setcode 'sudo cat /root/vmid'
end
