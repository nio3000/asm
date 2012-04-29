$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../../lib')

=begin
# /lib/Asm/require_all.rb
* hardcoded require for each file containing code under module Asm
* dependency on module Asm should be resolved by requiring this file
	* no, don't bother just requiring the individual files you think you need.
=end

# misc functionality for consistency
require 'Asm/Literals_Are_Magic.rb'
require 'Asm/version.rb'
require 'Asm/Boilerplate.rb'

# the core functionality of the BCPU virtual machine
require 'Asm/BCPU.rb'
require 'Asm/Loader.rb'
require 'Asm/Virtual_Machine.rb'

# application specific functionality
require 'Asm/Program_Options.rb'
require 'Asm/Application.rb'

# encoding: UTF-8
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=ruby
