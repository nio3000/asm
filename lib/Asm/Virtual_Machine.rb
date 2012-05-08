=begin
# /lib/Asm/Virtual_Machine.rb
* complete definition of class Asm::Virtual_Machine
* unit tests on an instance of Asm::Virtual_Machine
=end


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
	* memory_values are allocated on demand & behavior is compatible with preallocation,
		but will be more memory efficient in the (expected) case of low memory utilization.
=end
	class	Virtual_Machine
	public
=begin
		structors & accessors
		* the instance variable @the_memory is a private implementation detail
		* the program counter is not an instance variable;
			it is the Asm::BCPU::Memory::Value associated with Asm::Magic::Register::Location::program_counter
=end
		# Initialize the virtual machine.
		def initialize( )
			# @the_memory is a hash
			#@the_memory	= { }
			@the_memory	= Hash.new
			#@the_memory.compare_by_identity
			#puts 'VM.initialze ,@the_memory.compare_by_identity?=' << ((@the_memory.compare_by_identity?) ? ('true') : ('false')) << ''
		end
	public
=begin
		invoke simulated BCPU execution
=end
		# DOCIT
		def advance_once
			# read the memory value of the program counter
			the_program_counter	= ::Asm::Magic::Register::Location::Program_counter
			the_program_counter_dereferenced	= ::Asm::BCPU::Memory::Location.new( self.get_memory_value( the_program_counter ).the_bits )
			the_machine_code	= self.get_memory_value( the_program_counter_dereferenced )
			op_code_binary_string	= ::Asm::Boilerplate::Machine::Code.get_OPcode_as_string( the_machine_code )
			if op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:move] )
				self.move( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:not] )
				self.not( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:and] )
				self.and( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:or] )
				self.or( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:add] )
				self.add( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:sub] )
				self.sub( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:addi] )
				self.addi( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(0..3) ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:subi] )
				self.subi( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(0..3) ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:set] )
				self.set( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ),Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(0..7) ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:seth] )
				self.seth( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ),Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(0..7) ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:inciz] )
				self.inciz( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ),Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(4..7) ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code )  )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:decin] )
				self.decin( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ),Asm::Boilerplate::Machine::Code.get_value_from_bit_range( the_machine_code ,(4..7) ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code )  )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:movez] )
				self.movez( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:movex] )
				self.movex( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:movep] )
				self.movep( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			elsif op_code_binary_string.eql?( Asm::Magic::ISA::Opcode::Binary::String[:moven] )
				self.moven( Asm::Boilerplate::Machine::Code.get_RD_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RA_location( the_machine_code ) ,Asm::Boilerplate::Machine::Code.get_RB_location( the_machine_code ) )
			else
				#puts	'BANKAI: ' + op_code_binary_string + " = " + Asm::Magic::ISA::Opcode::Binary::String[:move]
			end
		end
		# DOCIT
		def advance( steps )
			#puts 'chii' unless steps.integer?
			if	( steps > 0 )
				for index in 1..steps
					self.advance_once
				end
			else
				if	steps == 0
				else
					#puts "don't do that"
				end
			end
		end
	#private
=begin	execute simulated BCPU execution
=end
		# RD <- RA
		def move( dest_reg, reg_a)
			self.set_location_to_value(dest_reg, self.get_memory_value(reg_a))
			self.increment_program_counter( dest_reg )
		end

		# RD <- bitwise NOT RA
		def not( dest_reg, reg_a)
			ra = self.get_memory_value(reg_a)
			rb = self.get_memory_value(reg_b)
			self.set_location_to_value(dest_reg, ra.not(rb))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA bitwise AND RB
		def and( dest_reg, reg_a, reg_b)
			ra = self.get_memory_value(reg_a)
			rb = self.get_memory_value(reg_b)
			self.set_location_to_value(dest_reg, ra & rb)
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA bitwise OR RB
		def or( dest_reg, reg_a, reg_b)
			ra = self.get_memory_value(reg_a)
			rb = self.get_memory_value(reg_b)
			self.set_location_to_value(dest_reg, ra.bitwise_OR!(rb))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA + RB
		def add( dest_reg, reg_a, reg_b)
			ra = self.get_memory_value(reg_a)
			rb = self.get_memory_value(reg_b)
			self.set_location_to_value( dest_reg , ra.add_Word!(rb))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA - RB
		def sub( dest_reg, reg_a, reg_b)
			ra = self.get_memory_value(reg_a).to_i
			rb = self.get_memory_value(reg_b).to_i
			self.set_location_to_value(dest_reg, Asm::BCPU::Memory::Value.new(ra - rb))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA + 4bit data
		def addi( dest_reg, reg_a, reg_fourbit)
			ra = self.get_memory_value(reg_a).to_i			
			self.set_location_to_value(dest_reg, Asm::BCPU::Memory::Value.new( ra + reg_fourbit.to_i ))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- RA - 4bit data
		def subi( dest_reg, reg_a, reg_fourbit)
			ra = self.get_memory_value(reg_a).to_i			
			self.set_location_to_value(dest_reg, Asm::BCPU::Memory::Value.new( ra - reg_fourbit.to_i ))
			
			self.increment_program_counter( dest_reg )
		end

		# RD <- 8 0's followed by 8 bit data
		def set( dest_reg, reg_eightbit)
			Asm::Loader::map_bits_to_bits( 0..7,self.get_memory_value( dest_reg ), 0..7, reg_eightbit)
			self.increment_program_counter( dest_reg )
		end

		# RD <- 8bit data follow by RD7, RD6, ... RD0
		def seth( dest_reg, reg_eightbit)
			Asm::Loader::map_bits_to_bits( 8..15,self.get_memory_value( dest_reg ), 8..15, reg_eightbit)
			self.increment_program_counter( dest_reg )
		end

		# RD <- RD + 4bit data if RB == 0 (zero)
		def inciz( dest_reg, reg_fourbit, reg_b)
			dest_reg_altered	= false
			if self.get_memory_value( reg_b ).to_i == 0
				an_Integer	= self.get_memory_value( dest_reg ).to_i + reg_fourbit.to_i
				::Asm::Magic::Binary::Twos_complement.assert_valid( an_Integer )
				#var = self.get_memory_value( dest_reg )
				#var.add!( reg_fourbit.to_i )
				self.set_location_to_value( dest_reg ,::Asm::BCPU::Memory::Value.from_integer_as_twos_complement( an_Integer ) )
				#self.set_location_to_value( dest_reg , var)
				dest_reg_altered	= true
			end
			self.increment_program_counter( dest_reg ,dest_reg_altered )
		end
		# RD <- RD - 4bit data if RB15 == 1 (neg)
		def decin( dest_reg, reg_fourbit, reg_b )
			dest_reg_altered	= false
			if self.get_memory_value( reg_b ).to_i <= 0
				an_Integer	= self.get_memory_value( dest_reg ).to_i + reg_fourbit.to_i
				::Asm::Magic::Binary::Twos_complement.assert_valid( an_Integer )
				self.set_location_to_value( dest_reg ,::Asm::BCPU::Memory::Value.from_integer_as_twos_complement( an_Integer ) )
				#self.set_location_to_value( dest_reg ,self.get_memory_value( dest_reg ).add!( -(reg_fourbit.to_i) ) )
				dest_reg_altered	= true
			end
			self.increment_program_counter( dest_reg ,dest_reg_altered )
		end

		# RD <- RA if RB == 0 (zero)
		def movez( dest_reg, reg_a, reg_b)
			if self.get_memory_value( reg_b ).to_i == 0
				self.move( dest_reg ,reg_a )
			else
				self.increment_program_counter( dest_reg )
			end
		end

		# RD <- RA if RB != 0 (not zero)
		def movex( dest_reg, reg_a, reg_b)
			if self.get_memory_value( reg_b ).to_i != 0
				self.move( dest_reg ,reg_a )
			else
				self.increment_program_counter( dest_reg )
			end
		end

		# RD <- RA if RB15 == 0 (positive)
		def movep( dest_reg, reg_a, reg_b)
			if self.get_memory_value( reg_b ).the_bits[15] == 0
				self.move( dest_reg ,reg_a )
			else
				self.increment_program_counter( dest_reg )
			end
		end

		# RD <- RA if RB15 == 1 (negative)
		def moven( dest_reg, reg_a, reg_b)
			if self.get_memory_value( reg_b ).the_bits[15] == 1
				self.move( dest_reg ,reg_a )
			else
				self.increment_program_counter( dest_reg )
			end
		end
		# R15 <- R15 + 1
		def increment_program_counter( dest_reg ,dest_reg_altered = false ,an_Integer = 1 )
			#program_counter	= Asm::BCPU::Word.from_Bitset( Asm::Magic::Register::Location::Program_counter.the_bits ).to_i( false ,true )
			program_counter	= Asm::Magic::Register::Location::Program_counter.to_i
			#unless	( dest_reg.equal_to?( Asm::Magic::Register::Location::Program_counter ) && dest_reg_altered )
			if	( dest_reg.to_i == program_counter ) && dest_reg_altered
				#lhs = self.get_memory_value( Asm::Magic::Register::Location::Program_counter )
				temp	= ::Asm::BCPU::Memory::Location.new( self.get_memory_value( Asm::Magic::Register::Location::Program_counter ).the_bits ).to_i + an_Integer
				#lhs.add!( Asm::BCPU::Word.new( an_Integer ) ,false )	# should allow unsigned values to be assigned to program counter
				value	= ::Asm::BCPU::Memory::Value.new( ::Asm::BCPU::Memory::Location.new( temp ).the_bits )
				self.set_location_to_value( Asm::Magic::Register::Location::Program_counter ,value )
			end
			return
		end
	public
=begin
		BCPU memory manipulation
		* strict type checking is intended
		* incorrect types will #puts exceptions.
=end
		# Maps the memory location (@param location) to the memory value (@param value)
		# Returns nothing
		def set_location_to_value( location ,value )
			# paranoid type checking
			Asm::Boilerplate::#puts_unless_type( location ,Asm::BCPU::Memory::Location )
			Asm::Boilerplate::#puts_unless_type( value ,Asm::BCPU::Memory::Value )
			#puts 'VM#set_location_to_value( loc=' << location.to_s << ' ,val=' << value.to_s << ' )'
			# assignment; creates association if none existed, else overwrites.
			@the_memory[location.to_s]	= value
			#puts '	@the_memory[location.to_s=' << location.to_s << ']=' << @the_memory[location.to_s].to_s
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
			Asm::Boilerplate::#puts_unless_type( location ,Asm::BCPU::Memory::Location )
			# create association even if none exists
			if !@the_memory.has_key?( location.to_s )
				#puts 'location=' << location.to_s << ' was previously undefined'
				self.set_location_to_value( location ,Asm::BCPU::Memory::Value.new )
			else
				#puts 'QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ'
			end
			#puts 'Aya; @the_memory[location.to_s=' << location.to_s << ']=' << @the_memory[location.to_s].to_s unless @the_memory[location.to_s].instance_of?( Asm::BCPU::Memory::Value )
			# return association by value
			#return	Asm::BCPU::Memory::Value.from_Bitset( @the_memory[location.to_s].the_bits ) #.clone
			return	Asm::BCPU::Memory::Value.from_binary_String( @the_memory[location.to_s].the_bits.to_s ) #.clone
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
		# #putss exceptions when the memory range is invalid
		# Returns memory-location-ordered array of memory values
		def get_memory_range( inclusive_minimum ,exclusive_maximum )
			# paranoid type checking
			#puts 'haerierhaerh' unless inclusive_minimum.integer? && exclusive_maximum.integer?
			#puts "The minimum is not less than the maximum" unless inclusive_minimum < exclusive_maximum 
			# force all values available
			values	= []
			for index in (inclusive_minimum..(exclusive_maximum-1))
				values.push self.get_memory_value( ::Asm::BCPU::Memory::Location.from_integer_as_unsigned( index ) )
			end
=begin
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
			# TODO test that the ordering is correctly accomplished here
			locations.sort! { |lhs ,rhs| lhs.to_i( ) <=> rhs.to_i( ) }
			# retrieve for values for each location (preserves ordering)
			#locations.each { |key| values.push @the_memory[key] }
			locations.each { |key| values.push self.get_memory_value( key ) }
=end
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
		#class Test < Test::Unit::TestCase
		#end
	end
end

#require	'Asm/require_all.rb'
#$LOAD_PATH << '.'
# encoding: UTF-8
