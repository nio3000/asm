=begin
# /lib/Asm/Application.rb
* complete definition of class Asm::Application
=end

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm

=begin
	# Asm::Application
	* a complete and self-contained application object for a BCPU VM
	* will handle GUI details or something like that
=end
	class Application
		# DOCIT
		# TODO: Pass APP_CONFIG to here from bin/bcpuvm-cli?
		def initialize
			@the_BCPU	= Asm::Virtual_Machine.new
			@the_Loader	= Asm::Loader.new( @the_BCPU )
		end
		# DOCIT
		# TODO: Pass asm file here from bin/bcpuvm-cli?
		def run
			# TODO get a filename
			a_file	= ""
			#
			@the_Loader.load( a_file )
			# TODO integrate this with the GUI via callbacks or whatnot
		end
	end
end

#require	'Asm/require_all.rb'
$LOAD_PATH << '.'
# encoding: UTF-8
