module Puppet::Parser::Functions
  newfunction(:gentoken, :type => :rvalue) do |args|
    # Attributes to create token with
    aeskey = "3eafda76cb8b015641cb946708675423" # Replace me!
    exercise = args[0]
    buffersize = args[1]
    vmid = lookupvar('vmid')

    # Combine attributes together
    if buffersize != "" then
      data = exercise + "-" + buffersize + "-" + vmid[4..11]
    elsif
      data = exercise + vmid
    end

    if data.size < 16 then
      warning(exercise + " token is too short")
    elsif data.size > 16
      warning(exercise + " token is too long")
    end

    # Use cipher to generate token bytes
    cipher = OpenSSL::Cipher::AES.new(128, :ECB)
    cipher.encrypt
    cipher.key = aeskey.unpack('a2'*32).map{|x| x.hex}.pack('c'*32) # Convert key from hex to binary
    cipher.padding = 0
    encrypted = cipher.update(data) + cipher.final

    # Convert bytes into hex
    token = encrypted.unpack('H*').first

    return token
  end
end
