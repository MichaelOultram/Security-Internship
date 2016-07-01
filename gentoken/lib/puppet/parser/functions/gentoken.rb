module Puppet::Parser::Functions
  newfunction(:gentoken, :type => :rvalue) do |args|
    # Attributes to create token with
    aeskey = "3eafda76cb8b015641cb946708675423" # Replace me!
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
    token = encrypted.unpack('H*').first

    return token
  end
end
