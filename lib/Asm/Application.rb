=begin
# /lib/Asm/Application.rb
* complete definition of class Asm::Application
=end

require	'Asm/require_all.rb'

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm

=begin	# Asm::Application
	* a complete and self-contained application object for a BCPU VM
	* will handle GUI details or something like that
=end	
    class Application
		# DOCIT
		def initialize
			@the_BCPU	= Asm::Virtual_Machine.new
			@the_Loader	= Asm::Loader.new( @the_BCPU )
		end
		# DOCIT
		def run
			a_file	= ""	# TODO get a filename
			#
			@the_Loader.load( a_file )
			# TODO integrate this with the GUI via callbacks or whatnot
		end
	end
end
