module Puppet::Parser::Functions
  newfunction(:randNumber, :type => :rvalue) do |args|

	number = (99 > 10) ? 10 + rand((99-10+1)) : 99 +rand((10-99+1))
	return number.to_s
	end
end
