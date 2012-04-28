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
=end	
    class	Virtual_Machine
	public
=begin		structors & accessors
		* the instance variable @the_memory is a private implementation detail
		* the program counter is not an instance variable; it is the Asm::BCPU::Memory::Value associated with Asm::Magic::Register::Location::program_counter
=end
        # Initialize the virtual machine.
		def initialize( )
			# @the_memory is a hash
			@the_memory	= { }
		end
	public
=begin		invoke simulated BCPU execution
=end
		# DOCIT
		def advance_once
			# TODO implement # read the memory value of the program counter
			# dispatch based on opcode
				# make boilerplate code for splitting based on format
		end
		# DOCIT
		def advance( steps )
			# TODO implement
			# call advance_once number_of_times
		end
	private
=begin		execute simulated BCPU execution
=end
		# DOCIT
		def MOVE( destination_register ,registerA )
			# TODO implement
		end
		# TODO define all opcode cases
	public
=begin		BCPU memory manipulation
		* strict type checking is intended
			* incorrect types will raise exceptions.
=end
		# Maps the memory location (@param location) to the memory value (@param value)
		#
		# Returns nothing
		def set_location_to_value( location ,value )
			# paranoid type checking
			Asm::Boilerplate::raise_unless_type( location ,Asm::BCPU::Memory::Location )
			Asm::Boilerplate::raise_unless_type( value ,Asm::BCPU::Memory::Value )
			# assignment; creates association if none existed, else overwrites.
			@the_memory[location]	= value
			# return nothing
			return
		end
		# Returns by value the Asm::BCPU::Memory::Value mapped by the memory location (@param location)
		#
		# Will assign an Asm::BCPU::Memory::Value even if the association does not exist yet.
		#
		# Returns by value an Asm::BCPU::Memory::Value instance
		def get_memory_value( location )
			# paranoid type checking
			Asm::Boilerplate::raise_unless_type( location ,Asm::BCPU::Memory::Location )
			# create association even if none exists
			unless @the_memory.has_key?( location )
				self.set_location_to_memory_value( location ,Asm::BCPU::Memory::Value.new )
			end
			# return association by value
			return	@the_memory[location].clone
		end
		# Obtain values mapped by memory locations in the given range (@param inclusive_minimum, @paramexclusive_maximum)
		# 	values are obtained in order
		#	TODO document what the order is (ascending memory index or not)
		#
		# inclusive_minimum - Integer compatible type; lowest index in the desired range
		# exclusive_maximum - Integer compatible type; lowest index not in the desired range and greater than any index in the desired range
		#
		# computationally expensive; consider using orderedhash gem if this becomes a dealbreaker
		#
		# Raises exceptions when the memory range is invalid
		# Returns memory-location-ordered array of memory values
		def get_memory_range( inclusive_minimum ,exclusive_maximum )
			# paranoid type checking
			# TODO force integer-compatible types
			assert( inclusive_minimum < exclusive_maximum ,"The minimum is not less than the maximum" )
			# local state
			locations	= []
			values	= []
			# obtain order-agnostic array of locations
			@the_memory.each do |key ,value|
				if ( key.to_i >= inclusive_minimum ) && ( key.to_i < exclusive_maximum )
					locations.push key
				end
			end
			# order the locations as is natural for them
			locations.sort! { |lhs ,rhs| lhs.to_i( 2 ) <=> rhs.to_i( 2 ) }	# TODO test that the ordering is correctly accomplished here
			# retrieve for values for each location (preserves ordering)
			locations.each { |key| values.push @the_memory[key] }
			# return sorted values
			values
		end
=begin
		# Unit tests on this class
		* any claim made in documentation ought to have a unit tests
			* TODO implement the unit tests
		* all the major instructions needs unit tests
			* TODO implement the unit tests
=end		
        class Test < Test::Unit::TestCase
            test "" do
            end
		end # Test
	end # Virtual_Machine
end # Asm
