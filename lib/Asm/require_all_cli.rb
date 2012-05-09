=begin
# /lib/Asm/require_all.rb
* hardcoded require for each file containing code under module Asm
* dependency on module Asm should be resolved by requiring this file
	* no, don't bother just requiring the individual files you think you need.
=end

# 3rd party dependencies
require 'bitset'
require 'minitest/unit'
require 'test/unit/assertions'
module Asm
	class Tests
		include Test::Unit::Assertions
	end
end

# misc functionality for consistency
require 'Asm/Magic.rb'
require 'Asm/version.rb'
require 'Asm/Boilerplate.rb'

# the core functionality of the BCPU virtual machine
require 'Asm/BCPU.rb'
require 'Asm/Loader.rb'
require 'Asm/Virtual_Machine.rb'

# encoding: UTF-8
