# this file is undocumented, haha.
require	'Asm/require_all.rb'

# module Asm contains code relevant to the function of a BCPU VM.
module Asm
	# a Loader instance initializes a Virtual_Machine instance's memory.
	class	Loader
	# ---persistant member variables & an explanation of them & structors---
		# Public: get & set the_Virtual_Machine associated with this instance.
		attr_accessor :the_Virtual_Machine
		# Private: get & set the memory index at which the Loader will load machine code into the Virtual_Machine's memory. 
		attr_accessor :load_index
		# Public: initialize Loader instance with reference to a Virtual_Machine
		#
		# the_Virtual_Machine	- reference to a Virtual_Machine instance
		def initialize( the_Virtual_Machine )
			# paranoid type checking of arguments.
			raise_unless_type( the_Virtual_Machine ,Asm::Virtual_Machine )
			# initialize all persistant member variables.
			@the_Virtual_Machine	= the_Virtual_Machine
			@load_index	= Asm::Literals_Are_Magic::Loader::example_invalid_load_index
		end
	# ---messages to Loader instance regarding handling the task of parsing BCPU assembly---
		# Public: invoke Loader instance with a given file of BCPU assembly
		def load( file )
			#...
			#for each line in file,
			#	classify the line
			#		Regexp match, y/n
			#		context appropriate, y/n
			#	obtain the relevant info from the line
			#		Regex match, named captures
			#		valid, y/n
			#	pass that information to Loader.relevant functionality.
			#		do it
			#		valid, y/n
		end
		# Private: dispatch messages based on the given line of text.
		def handle( line_of_text )
			# ...
		end
	# ---messages to Loader instance regarding handling specific instances of BCPU assembly syntax---
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			...
		end
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__asm( memory_location_literal )
			...
		end
	end
end