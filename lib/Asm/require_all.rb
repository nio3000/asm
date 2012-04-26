# this file is hard-coded to require all other files containing code under module asm.
#	code dependent on code under module asm can require this file instead of attempting to require files by name explicitly.

# misc functionality for consistency
require 'Asm/Literals_Are_Magic.rb'
require 'Asm/version.rb'
require 'Asm/Boilerplate.rb'

# the core functionality of the BCPU virtual machine
require 'Asm/Loader.rb'
require 'Asm/Virtual_Machine.rb'

# application specific functionality
require 'Asm/Program_Options.rb'
require 'Asm/Application.rb'
