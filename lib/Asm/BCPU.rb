# encoding: UTF-8

=begin
# /lib/Asm/BCPU.rb
* complete definition of class Asm::BCPU::Word and inheritors Asm::BCPU::Memory::Location and Asm::BCPU::Memory::Value
* isloated helper methods under modules Asm::BCPU::Memory::Index and Asm::BCPU::Register
* unit tests on instances of Asm::BCPU::Word,Asm::BCPU::Memory::Location, and Asm::BCPU::Memory::Value
* largely undocumented and unimplemented
=end
module Asm
	# DOCIT
	module BCPU
=begin	# Asm::BCPU::Word
		* a Word is the fundamental data type in the BCPU
			* Asm::BCPU::Memory::Location inherits from Asm::BCPU::Word
				* memory locations have a subtly different context for assignment operations (no two's complement)
			* Asm::BCPU::Memory::Value inherits from Asm::BCPU::Word
=end
		class Word
		public
=begin		structors & accessors
			* the instance variable @the_bits is a Bitset
				* see the repo for Bitset for details & methods available if you need to get at indivudal bits in the Bitset
=end
			# get @the_bits
			attr_reader :the_bits
			# initializing constructor, implicitly default constructor
			#
			# argument - see Asm::BCPU::Word::assign for restrictions
			# Force_twos_complement - see Asm::BCPU::Word::assign for usage
			def initialize( An_object = nil ,Force_twos_complement = true )
				self.assign( An_object ,Force_twos_complement )
			end
			# Creates a new instance of Asm::BCPU::Word, initialized to the values in self
			# const copy constructor
			def clone
				return	Asm::BCPU::Word.new( self )
			end
		public
=begin		implementation details, assignment
=end
			# Assign the bits in self to be the bits represented by the given object.
			# dispatches to type-specific assign methods, see those methods for constraints & behavior
			#
			# An_object - String, Integer-compatible, Bitset, or Asm::BCPU::Word
			# Force_twos_complement - T: whenever possible, force the encoding choice to be twos complement.
			#
			# Raises when input is invalid
			# Returns nothing
			def assign( An_object = nil ,Force_twos_complement = true )
				if An_object == nil	# Bitset initialized to 16 bits of zeros.
					@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )
				elsif Asm::Boilerplate::true_if_type( An_object ,String )
					self.assign_String( An_object ,Force_twos_complement )
				elsif Asm::Boilerplate::true_if_type( An_object ,Integer ) # TODO double check that this catches all integer compatible types
					self.assign_Integer( An_object ,Force_twos_complement )
				elsif Asm::Boilerplate::true_if_type( An_object ,Bitset )
					self.assign_Bitset( An_object )
				elsif Asm::Boilerplate::true_if_type( An_object ,Asm::BCPU::Word )
					self.assign_BCPU_Word( An_object )
				end
			end
			# Assign the bits in self to be number represented in the String; supports signed decimal integers (+|-)?[0-9] and binary [01]+
			def assign_String( A_String ,Force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( A_String ,String )
				# delegation
				if A_String.size == A_String.count( '01' ) # T: binary String
					self.assign_decimal_String( A_String ,Force_twos_complement )
				elsif A_String.size == A_String.count( '+-0123456789' )	# T: decimal or binary String
					self.assign_binary_String( A_String )
				else
					assert( false ,"the string contains characters not in the subset expected by the method." )	;
				end
			end
			# Assign the bits in self to be the binary representation of decimal value in the given String
			def assign_decimal_String( A_String ,Force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( A_String ,String )
				# pure decimal string checking
				assert( A_String.size == A_String.count( '+-0123456789' ) ,'the decimal string does not contain only \'+\', \'-\', and [0-9].' )
				# convert to Integer
				An_integer	= A_String.to_i( 10 )
				# dispatch to new method
				self.assign_integer( An_integer ,Force_twos_complement )
			end
			# Assign the bits in self to be the binary representation of the given integer
			#
			# Force_twos_complement
			# 	T: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement
			# 	F: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement iff An_integer < 0; else will delegate assignment to Asm::BCPU::Word::assign_integer_as_unsigned
			def assign_integer( An_integer ,Force_twos_complement = true )
				# paranoid type checking
				# TODO force integer compatible type
				# loose range checking based on known binary encodings (unsigned union twos-complement)
				# TODO maybe; refactor range checking from other assign_integer_as_... methods into boilerplate or magic; reuse
				# delegate to new method
				if Force_twos_complement
					self.assign_integer_as_twos_complement( An_integer )
				else
					if An_integer < 0
						self.assign_integer_as_twos_complement( An_integer )
					else
						self.assign_integer_as_unsigned( An_integer )
					end
				end
			end
			# Assign the bits in self to be the twos_complement representation of the given integer
			def assign_integer_as_twos_complement( An_integer )
				# paranoid type checking
				# TODO force integer compatible type
				# twos complement range checking
				Exclusive_max	= 2 ** (Asm::Magic::Memory::Bits_per::Word - 1)
				Exclusive_min	= -(Exclusive_max + 1)
				assert( An_integer < Exclusive_max ,'The integer is too positive for twos complement encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				assert( Exclusive_min < An_integer ,'The integer is too negative for twos complement encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				# convert to binary String twos complement encoding
				A_String	= An_integer.to_s
				# TODO verify whether or not the binary String faithfully represents negative values in twos complement (I don't think it does)
				assert( A_String.size == A_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# dispatch to new method
				self.assign_binary_String( A_String )
			end
			# Assign the bits in self to be the unsigned binary representation of the given integer
			def assign_integer_as_unsigned( An_integer )
				# paranoid type checking
				# TODO force integer compatible type
				# unsigned range checking
				Exclusive_max	= 2 ** (Asm::Magic::Memory::Bits_per::Word)
				Exclusive_min	= -1
				assert( An_integer < Exclusive_max ,'The integer is too positive for unsigned binary encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				assert( Exclusive_min < An_integer ,'The integer is too negative for unsigned binary encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				# convert to binary String unsigned binary encoding
				A_String	= An_integer.to_s
				assert( A_String.size == A_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# dispatch to new method
				self.assign_binary_String( A_String )
			end
			# Assign the bits in self to be the bits in the given binary String
			def assign_binary_String( A_String )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( A_String ,String )
				# pure binary string checking
				assert( A_String.size == A_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# convert to Bitset; this may or may not be the appropriate length, but dispatch will correct for that
				A_Bitset	= Bitset.from_s( A_String )
				# dispatch to new method
				self.assign_Bitset( A_Bitset )
			end
			# Assign the bits in self to be the bits in the given Asm::BCPU::Word
			def assign_BCPU_Word( A_BCPU_Word )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( A_BCPU_Word ,Asm::BCPU::Word )
				# dispatch to new method
				self.assign_Bitset( A_BCPU_Word.the_bits )
			end
			# Assign the bits in self to be the bits in the given Bitset
			#
			# Raises when input is invalid
			# Returns nothing
			def assign_Bitset( A_Bitset )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( A_Bitset ,Bitset )
				# content preservation checking
				assert( A_Bitset.size <= Asm::Magic::Memory::Bits_per::Word ,"The bitset contains more than "<<Asm::Magic::Memory::Bits_per::Word<<"bits; assigning it may lose information in an unintended way." )
				# make the assignment to @the_bits
				@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )	# 0000 0000 0000 0000
				self.bitwise_OR!( A_Bitset )	# 1s from A_Bitset will appear in @the_bits
				return
			end
		private
=begin		implementation details
=end
			# Bitset's bitwise-or (aka '|') is broken (in one usage case only), don't use it.
			# If for some reason you need that, then use this instead.
			#
			# Modifies self
			# Returns nothing
			def bitwise_OR!( An_object )	# TODO verify this preserves size
				# switch case on type; fuck duck typing.
				if Asm::Boilerplate::true_if_type( An_object ,Asm::Virtual_Machine::Word )
					@the_bits | An_object.the_bits	# non borken usage case; Bitset instances are same size
				elsif Asm::Boilerplate::true_if_type( An_object ,Bitset )
					assert( !(An_object.size < @the_bits.size) , "implementation fault: Bitset's | operation is broken in the case you tried to use it in; ask for a workaround asap." )
					@the_bits | An_object
					# TODO (Bitset lhs) | (Bitset rhs) is broken when rhs.size < lhs.size
				else
					assert( false ,'Ojou-sama, that is inappropriate.' )
				end
				return
			end
			# Obtain a binary String of the bits in self
			def to_s( )
				@the_bits.to_s
				# TODO check for consistency between endianness in Word.new( '01' ) and Word.new( '01' ).to_s
			end
		end
		# DOCIT
		module Memory
			# DOCIT
			class Location < Asm::BCPU::Word
				# DOCIT
				#
				# argument - DOCIT
				#
				# DOCIT
				def initialize( argument = nil )
					self.assign( argument )
				end
				# DOCIT
				def to_i( )
					# TODO implement this; assume unsigned encoding of binary values
				end
				# DOCIT
				def to_s( )
					# TODO implement this; assume unsigned encoding of binary values
				end
				# DOCIT
				def less_than?( rhs )
					if Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Memory_Location )
						return	self.to_i( ) < rhs.to_i( )
					elsif Asm::Boilerplate::true_if_type( argument ,Integer )
						return	self.to_i( ) < rhs
					else
						raise "wtf; stop it"
						# TODO reduce exception boilerplate
					end
				end
				# DOCIT
				def equal_to?( rhs )
					if Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Memory_Location )
						return	self.to_i( ).equal?( rhs.to_i( ) )
					elsif Asm::Boilerplate::true_if_type( argument ,Integer )
						return	self.to_i( ).equal?( rhs )
					else
						raise "wtf; stop it"
						# TODO reduce exception boilerplate
					end
				end
				# DOCIT
				def valid?
					return	Asm::BCPU::Memory::Index::valid?( self.to_i( ) )
				end
			end
			# DOCIT
			class Value < Asm::BCPU::Word
				# DOCIT
				def to_i( signed = true )
					# TODO implement this
				end
			end
			# DOCIT
			module Index
				# DOCIT
				def valid?( argument )
					return	(argument >= Asm::Literals_Are_Magic::Memory::inclusive_minimum_index) && (argument < Asm::Literals_Are_Magic::Memory::exclusive_maximum_index) 
				end
			end
		end
		# DOCIT
		module Register
			# DOCIT
			def location( register_literal )
				# TODO make an instance of Memory::Location based on /R[0-9]+/
			end
		end
=begin
		# Unit tests on this class
		* any claim made in documentation ought to have a unit tests
			* TODO implement the unit tests
=end		
        class Test < Test::Unit::TestCase
        end
end

require	'Asm/require_all.rb'
