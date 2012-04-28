=begin
# /lib/Asm/Virtual_Machine.rb
* complete definition of class Asm::Virtual_Machine
* unit tests on an instance of Asm::Virtual_Machine
=end

require	'Asm/require_all.rb'

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin
# Asm::Virtual_Machine
* persistant BCPU internal state.
	* BCPU memory locations mapped to BCPU memory values
	* BCPU register literals mapped to BCPU memory locations
* invokable inplace modifications to simulate execution affecting BCPU internal state.

### representing BCPU memory locations as objects
see Asm::BCPU::Memory::Location

### representing BCPU memory values as objects
see Asm::BCPU::Memory::Value

### implementation details
* BCPU memory is represented as an associative array (Ruby Hash)
	* memory_values are allocated on demand & behavior is compatible with preallocation, but will be more memory efficient in the (expected) case of low memory utilization.
=end	class	Virtual_Machine
=begin		public: structors & accessors
		* the instance variable @the_memory is a private implementation detail
		* the program counter is not an instance variable; it is the Asm::BCPU::Memory::Value associated with Asm::BCPU::Memory::Location.new( )
=end
		# initializing default constructor
		def initialize( )
			# @the_memory is a hash (collection of key -> value pairs)
			@the_memory	= { }
		end
=begin		public: BCPU memory manipulation
		* strict type checking is intended
			* incorrect types will raise exceptions.
=end
		# DOCIT
		#
		# Returns nothing
		def set_memory_location_to_memory_value( memory_location ,memory_value )
			# paranoid type checking
			Asm::Boilerplate::raise_unless_type( memory_location ,Asm::BCPU::Memory::Location )
			Asm::Boilerplate::raise_unless_type( memory_value ,Asm::BCPU::Memory::Value )
			# assignment; creates association if none existed, else overwrites.
			self.the_memory[memory_location]	= memory_value
			return
		end
		# DOCIT
		#
		# Will assign an Asm::BCPU::Memory::Value if the association does not exist yet.
		#
		# Returns the Asm::BCPU::Memory::Value mapped by memory_location
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
		# inclusive_minimum - Integer compatible type; lowest index in the desired range
		# exclusive_maximum - Integer compatible type; lowest index not in the desired range and greater than any index in the desired range
		#
		# computationally expensive; consider using orderedhash gem if this becomes a dealbreaker
		#
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
=begin
		# Unit tests on this class
		* any claim made in documentation ought to have a unit tests
			* TODO implement the unit tests
=end		class Test < Test::Unit::TestCase
		end
	end
end
