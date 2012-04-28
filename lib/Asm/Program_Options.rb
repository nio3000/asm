# encoding: UTF-8

=begin
# /lib/Asm/Program_Options.rb
* probably going to be deleted
=end


=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
	# placeholder for a program options object class; will handle harvesting program options; will handle initializing some instances.
	class	Program_Options
        def read_config
           config = YAML.load_file("config.yaml")
           @mem_bpw = config["memory"]["bits_per_word"]
           # ... etc.
        end
	end
end

require	'Asm/require_all.rb'
require 'yaml'
