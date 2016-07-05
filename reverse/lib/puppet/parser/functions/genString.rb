module Puppet::Parser::Functions
  newfunction(:genString, :type => :rvalue) do |args|

	range = Array.new(4){rand(36).to_s(36)}.join
	return range
	end
end
