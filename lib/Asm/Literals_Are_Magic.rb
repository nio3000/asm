# this file contains the boilerplate and magic numbers/literals used with module Asm.
#
# design choice:
# 	if your code has a number (Ruby) literal hardcoded in it,
# 	then you should consider how or why you could instead hardcode that value in Asm::Literals_Are_Magic.
#
# design choice:
# 	nested modules improve readability,
# 	allow simpler variable names,
# 	and are a good idea;
# 	I don't care if it takes you forever to type the full nested name,
# 	this design choice is for reading them.
require	'Asm/require_all.rb'

# module Asm contains code relevant to the function of a BCPU VM.
module Asm
	# the residence of hardcoded magic numbers, literals & related methods
	#
	# Examples
	# 	puts Literals_Are_Magic::Memory::inclusive_minimum_index #=> 0
	#
	# nested modules are used to facilitate reorganization & renaming later as well as to allow us to indulge in explanatory variable names.
	module	Literals_Are_Magic
		# Asm::Loader related magic
		module	Loader
			# a safe to use invalid load index that should be assigned anytime the Loader's load index needs to be in an invalid (unusable) state.
			example_invalid_load_index	= -666
		end
		# Asm::Virtual_Machine Memory related magic
		module	Memory
			# one word is the value associated with a memory location
			bits_per_word	= 16
			bits_per_halfword	= 8
			bits_per_quarterword	= 4
			# memory locations are homomorphic to integers, so determining contiguous memory locations is reduced to integer calculations
			inclusive_minimum_index	= 0
			exclusive_maximum_index	= 2^16
		end
		# Asm::Virtual_Machine Register related magic
		module	Register
			# register locations are homomorphic to integers, so determining contiguous contiguous locations is reduced to integer calculations
			inclusive_minimum_index	= 0
			exclusive_maximum_index	= 2^4
			# special registers, integer indicies
			program_counter_index	= 15
			input_register_indicies	= [ 6 ]
			output_register_indicies	= [ 13 ,14 ]
			# special registers, memory locations
			program_counter_memory_location	= Bitset.new( '0000000000001111' )
			input_register_memory_locations	= [ Bitset.new( '0000000000000110' ) ]
			output_register_memory_locations	= [ Bitset.new( '0000000000001101' ) ,Bitset.new( '0000000000001110' ) ]
		end
	end
end