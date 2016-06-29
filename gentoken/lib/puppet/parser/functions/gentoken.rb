module Puppet::Parser::Functions
  newfunction(:gentoken, :type => :rvalue) do |args|
    # Attributes to create token with
    aeskey = "fd5d148867091d7595c388ac0dc50bb465052b764c4db8b4b4c3448b52ee0b33df16975830acca82" # Replace me!
    exercise = args[0]
    vmid = lookupvar('vmid')

    # Combine attributes together
    data = exercise + "-" + vmid

    # Use cipher to generate token bytes
    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.encrypt
    cipher.key = aeskey
    encrypted = cipher.update(data) + cipher.final

    # Convert bytes into hex
    token = encrypted.each_byte.map { |b| b.to_s(16) }.join
    return token
  end
end
