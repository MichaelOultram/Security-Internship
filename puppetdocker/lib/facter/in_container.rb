Facter.add(:in_container) do
  setcode do
    Facter::Core::Execution.exec("[ -f /root/build.sh ] && echo true || echo false")
  end
end
