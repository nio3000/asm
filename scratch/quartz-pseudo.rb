def	raise_unless_type( argument ,type )
	raise "argument's type is " << argument.kind?() << ", not " << type.inspect() << "." unless argument.kind? == type
end

# the residence of hardcoded magic numbers & literals
#
# Examples
# 	puts Literals_are_magic::Memory::inclusive_minimum_index #=> 0
#
# nested modules are used to facilitate reorganization & renaming later as well as to allow us to indulge in explanatory variable names.
module	Literals_are_magic
	# Virtual_Machine Memory related magic
	module	Memory
		# one word is the value associated with a memory location
		bits_per_word	= 16
		bits_per_halfword	= 8
		bits_per_quarterword	= 4
		# memory locations are homomorphic to integers, so determining contiguous memory locations is reduced to integer calculations
		inclusive_minimum_index	= 0
		exclusive_maximum_index	= 2^16
		# special registers
	end
	# Virtual_Machine Register related magic
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

class	Program_Options
end

class	Application
end

module	BCPU
	# a Loader instance initializes a Virtual_Machine instance's memory.
	class	Loader
		# Public: get & set the_Virtual_Machine associated with this instance.
		attr_accessor :the_Virtual_Machine
		# Public: initialize Loader instance with reference to a Virtual_Machine
		#
		# the_Virtual_Machine	- reference to a Virtual_Machine instance
		def initialize( the_Virtual_Machine )
			raise_unless_type( the_Virtual_Machine ,BCPU::Virtual_Machine )
			@the_Virtual_Machine	= the_Virtual_Machine
		end
		attr_accessor :passive_target
		# Public: invoke Loader instance with a given file of BCPU assembly
		def load( file )
			...
			for each line in file,
				classify the line
					Regexp match, y/n
					context appropriate, y/n
				obtain the relevant info from the line
					Regex match, named captures
					valid, y/n
				pass that information to Loader.relevant functionality.
					do it
					valid, y/n
		end
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			...
		end
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__asm( memory_location_literal )
			...
		end
	end

DESIGN FAIL:
blarg, memory location concept needs to be altared
presently, unequal strings represent the same memory location.
	# a Virtual_Machine instance preserves the internal state of a BCPU and can simulate that BCPU excution affects its internal state.
	class	Virtual_Machine
		# Public: initialize Virtual_Machine instance
		def initialize( )
			# the_memory is a hash (collection of key -> value pairs)
			@the_memory	= { }
		end
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
		# Private: arbitrary range checking on memory locations
		#
		# memory_location - a String containing binary digits
		# inclusive_minimum - Integer; lowest index in the desired range
		# exclusive_maximum - Integer; lowest index not in the desired range and greater than any index in the desired range
		#
		# Raises exceptions when the memory range is invalid
		# (implicit) Raises exceptions when the memory_location is invalid
		# Returns true if the given memory_location is a valid memory location and if it memory location is in the memory range; else false
		def valid_memory_location_in_memory_range?( memory_location ,inclusive_minimum ,exclusive_maximum )
			# type checking
			raise_unless_type( inclusive_minimum ,Integer ) # decimal integer
			raise_unless_type( exclusive_maximum ,Integer ) # decimal integer
			raise "inclusive_minimum is not less than exclusive_maximum." unless inclusive_minimum < exclusive_maximum
			integer_location	= self.valid_memory_location( memory_location ).to_i( 2 )
			# verification
			return (inclusive_minimum <= integer_location) && (exclusive_maximum > integer_location)
		end
		# Private: memory_value checking & recovery
		#
		# memory_value - Bitset; represents a word
		#
		# Raises exceptions when the memory_value is invalid
		# Returns the validated (possibly altered;recovered) memory value
		def valid_memory_value( memory_value )
			# type checking
			raise_unless_type( value ,Bitset )
			#	could potentially recover a string by instantiating a Bitset from it.
			# bit amount checking
			raise "invalid value, too many bits" if value.size > Literals_are_magic::Memory::bits_per_word
			#	could potentially recover by testing for leading zeros & removing them
			raise "invalid memory location, out of range" if value.size < Literals_are_magic::Memory::bits_per_word
			#	could potentially recover by prepending leading zeros
			# return validated memory_value
			return memory_value
		end
		# Private: generation of memory values for undefined behavior that is defined to actually work.
		#
		# Returns the a validated memory value
		def undefined_memory_value
			return Bitset.new( Literals_are_magic::Memory::bits_per_word )
		end
		# Public: set the value associated with a memory location; does validity checking
		#
		# memory_location - a String containing binary digits
		# memory_value - Bitset; represents a word
		#
		# (implicit) Raises exceptions when the memory_location is invalid
		# (implicit) Raises exceptions when the memory_value is invalid
		# Returns nothing
		def set_memory_location_to_bitset( memory_location ,memory_value )
			@the_memory[self.valid_memory_location( memory_location )]	= self.valid_memory_value( memory_value )
			return
		end
		# Public: get the value associated with a memory location; does validity checking; will create association if none exists.
		#
		# memory_location - a String containing binary digits
		#
		# (implicit) Raises exceptions when the memory_location is invalid
		# Returns the value associated with memory_location.
		def get_memory_location( memory_location )
			# type checking
			validated_memory_location	= self.valid_memory_location( memory_location )
			# create association if none exists
			unless @the_memory.has_key?( validated_memory_location )
				@the_memory[validated_memory_location]	= self.undefined_memory_value
			end
			# return association
			return	@the_memory[validated_memory_location]
		end
		# Public: get the values associated with a range of memory locations; does validity checking; values are presented in order
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
			an_array_of_memory_values	= []
			@the_memory.each do |key ,value|
				if self.valid_memory_location_in_memory_range( key ,inclusive_minimum ,exclusive_maximum )
					an_array_of_memory_values.push value
			end
			# haha
			an_array_of_memory_values.sort! { |lhs ,rhs| lhs.to_i( 2 ) <=> rhs.to_i( 2 ) }
			# return sorted array
			an_array_of_memory_values
		end
	end
end
