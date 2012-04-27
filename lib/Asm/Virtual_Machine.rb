# DOCIT

require	'Asm/require_all.rb'

# module Asm contains code relevant to the function of a BCPU VM.
module Asm
	# a Virtual_Machine instance preserves the internal state of a BCPU and can simulate that BCPU excution affects its internal state.
	class	Virtual_Machine
		# Public: initialize Virtual_Machine instance
		def initialize( )
			# the_memory is a hash (collection of key -> value pairs)
			@the_memory	= { }
		end
		# Public: set the value associated with a memory location
		#
		# memory_location - DOCIT
		# memory_value - DOCIT
		#
		# (implicit) Raises exceptions when the memory_location is invalid
		# (implicit) Raises exceptions when the memory_value is invalid
		# Returns nothing
		def set_memory_location_to_memory_value( memory_location ,memory_value )
			Asm::Boilerplate::raise_unless_type( memory_location ,Asm::BCPU::Memory::Location )
			Asm::Boilerplate::raise_unless_type( memory_value ,Asm::BCPU::Memory::Value )
			self.the_memory[memory_location]	= memory_value
			return
		end
		# Public: get the value associated with a memory location; does validity checking; will create association if none exists. DOCIT
		#
		# memory_location - a String containing binary digits
		#
		# (implicit) Raises exceptions when the memory_location is invalid
		# Returns the value associated with memory_location.
		def get_memory_value( memory_location )
			Asm::Boilerplate::raise_unless_type( memory_location ,Asm::BCPU::Memory::Location )
			# create association if none exists
			unless self.the_memory.has_key?( memory_location )
				self.set_memory_location_to_memory_value( memory_location ,Asm::BCPU::Memory::Value.new )
			end
			# return association
			return	self.the_memory[memory_location]
		end
		# Public: get the values associated with a range of memory locations; does validity checking; values are presented in order; DOCIT
		#
		# inclusive_minimum - Integer; lowest index in the desired range
		# exclusive_maximum - Integer; lowest index not in the desired range and greater than any index in the desired range
		#
		# Examples
		#
		# 	# the GUI needs to show a 'window' into the memory that tracks the location of the program counter
		#	the_Virtual_Machine.get_memory_range( ...tba... )
		#
		# computationally expensive; consider using orderedhash gem if this becomes a dealbreaker
		# (implicit) Raises exceptions when the memory range is invalid
		# Returns ordered array
		def get_memory_range( inclusive_minimum ,exclusive_maximum )
			# obtain order-agnostic array
			existant_locations	= []
			an_array_of_memory_values	= []
			self.the_memory.each do |key ,value|
				if ( key.to_i( ) >= inclusive_minimum ) && ( key.to_i( ) < exclusive_maximum )
					existant_locations.push key
				end
			end
			# haha
			existant_locations.sort! { |lhs ,rhs| lhs.to_i( 2 ) <=> rhs.to_i( 2 ) }
			existant_locations.each do |key|
				an_array_of_memory_values.push( self.the_memory[key] )
			end
			# return sorted array
			an_array_of_memory_values
		end
	end
end


###
# Private: memory_location checking & recovery
		#
		# memory_location - a String containing binary digits
		#
		# well-formed memory locations are represented by String instances containing unsigned binary
		#	todo: verify whether or not this method correctly interprets "1111" as unsigned instead of signed
		# valid memory locations represent an integer in the range [Literals_are_magic::Memory::inclusive_minimum_index ,Literals_are_magic::Memory::exclusive_maximum_index)
		# memory locations do not have to be 16 bits to be valid! They only need translate to an appropriate integer value when subjected to ".to_i( 2 )"
		# 	hint: when breaking up a memory value in to chunks of binary, a chunk representing a register can be used as a valid memory location.
		#
		# Raises exceptions when the memory_location is invalid
		# Returns the validated (possibly altered;recovered) memory location
		def valid_memory_location( memory_location )
			# type checking
			raise_unless_type( memory_location ,String )
			raise "invalid memory location, contains characters other than '0' and '1'" unless memory_location.count( "01" ) == memory_location.size
			# range checking
			integer_location	= memory_location.to_i( 2 )
			raise "invalid memory location, out of range" if integer_location >= Literals_are_magic::Memory::inclusive_minimum_index
			raise "invalid memory location, out of range" if integer_location < Literals_are_magic::Memory::exclusive_maximum_index
			# return validated memory_location
			return memory_location
		end
###