require 'openssl'

module Puppet::Parser::Functions
  newfunction(:gen_rsa_pair, :type => :rvalue) do |args|
    key_name = args[0]
    # Check to see if we already generated a key
    if File.file?("/tmp/rsakey-" + key_name) and File.file?("/tmp/rsakey-" + key_name + ".pub") then
      # Load keys from tmp file
      private_key = File.open("/tmp/rsakey-" + key_name, "rb") { |f| f.read }
      public_key = File.open("/tmp/rsakey-" + key_name + ".pub", "rb") { |f| f.read }
      return [public_key, private_key]
    else
      # Generate a new key and save in /tmp
      rsa_key = OpenSSL::PKey::RSA.new(2048)
      File.open("/tmp/rsakey-" + key_name + ".pub", "w") { |f| f.write rsa_key.public_key.to_pem }
      File.open("/tmp/rsakey-" + key_name, "w") { |f| f.write rsa_key.to_pem }
      return [rsa_key.public_key.to_pem, rsa_key.to_pem]
    end
  end
end
