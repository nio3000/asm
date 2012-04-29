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
			attr_writer :the_bits
			# initializing constructor, implicitly default constructor
			#
			# argument - see Asm::BCPU::Word::assign for restrictions
			# force_twos_complement - see Asm::BCPU::Word::assign for usage
			def initialize( an_Object = nil ,force_twos_complement = true )
				self.assign( an_Object ,force_twos_complement )
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
			# an_Object - String, Integer-compatible, Bitset, or Asm::BCPU::Word
			# force_twos_complement - T: whenever possible, force the encoding choice to be twos complement.
			#
			# Raises when input is invalid
			# Returns nothing
			def assign( an_Object = nil ,force_twos_complement = true )
				if an_Object == nil	# Bitset initialized to 16 bits of zeros.
					@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )
				elsif Asm::Boilerplate::true_if_type( an_Object ,String )
					self.assign_String( an_Object ,force_twos_complement )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Integer ) # TODO double check that this catches all integer compatible types
					self.assign_Integer( an_Object ,force_twos_complement )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Bitset )
					self.assign_Bitset( an_Object )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Asm::BCPU::Word )
					self.assign_BCPU_Word( an_Object )
				else
					raise 'Waku waku!'
				end
			end
			# Assign the bits in self to be number represented in the String; supports signed decimal integers (+|-)?[0-9] and binary [01]+
			def assign_String( a_String ,force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_String ,String )
				# delegation
				if a_String.size == a_String.count( '01' ) # T: binary String
					self.assign_binary_String( a_String )
				elsif a_String.size == a_String.count( '+-0123456789' )	# T: decimal or binary String
					self.assign_decimal_String( a_String ,force_twos_complement )
				else
					assert( false ,"the string contains characters not in the subset expected by the method." )	;
				end
			end
			# Assign the bits in self to be the binary representation of decimal value in the given String
			def assign_decimal_String( a_String ,force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_String ,String )
				# pure decimal string checking
				assert( a_String.size == a_String.count( '+-0123456789' ) ,'the decimal string does not contain only \'+\', \'-\', and [0-9].' )
				# convert to Integer
				an_Integer	= a_String.to_i( 10 )
				# dispatch to new method
				self.assign_integer( an_Integer ,force_twos_complement )
			end
			# Assign the bits in self to be the binary representation of the given integer
			#
			# force_twos_complement
			# 	T: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement
			# 	F: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement iff an_Integer < 0; else will delegate assignment to Asm::BCPU::Word::assign_integer_as_unsigned
			def assign_integer( an_Integer ,force_twos_complement = true )
				# paranoid type checking
				# TODO force integer compatible type
				# loose range checking based on known binary encodings (unsigned union twos-complement)
				# TODO maybe; refactor range checking from other assign_integer_as_... methods into boilerplate or magic; reuse
				# delegate to new method
				if force_twos_complement
					self.assign_integer_as_twos_complement( an_Integer )
				else
					if an_Integer < 0
						self.assign_integer_as_twos_complement( an_Integer )
					else
						self.assign_integer_as_unsigned( an_Integer )
					end
				end
			end
			# Assign the bits in self to be the twos_complement representation of the given integer
			def assign_integer_as_twos_complement( an_Integer )
				# paranoid type checking
				# TODO force integer compatible type
				# twos complement range checking
				assert( an_Integer < Asm::Magic::Binary::Twos_complement::Exclusive::Maximum ,'The integer is too positive for twos complement encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				assert( Asm::Magic::Binary::Twos_complement::Exclusive::Minimum < an_Integer ,'The integer is too negative for twos complement encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				# convert to binary String twos complement encoding
				a_String	= an_Integer.to_s
				# TODO verify whether or not the binary String faithfully represents negative values in twos complement (I don't think it does)
				assert( a_String.size == a_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# dispatch to new method
				self.assign_binary_String( a_String )
			end
			# Assign the bits in self to be the unsigned binary representation of the given integer
			def assign_integer_as_unsigned( an_Integer )
				# paranoid type checking
				# TODO force integer compatible type
				# unsigned range checking
				assert( an_Integer < Asm::Magic::Binary::Unsigned::Exclusive::Maximum ,'The integer is too positive for unsigned binary encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				assert( Asm::Magic::Binary::Unsigned::Exclusive::Minimum < an_Integer ,'The integer is too negative for unsigned binary encoded in '<<Asm::Magic::Memory::Bits_per::Word<<'bits.' )
				# convert to binary String unsigned binary encoding
				a_String	= an_Integer.to_s
				assert( a_String.size == a_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# dispatch to new method
				self.assign_binary_String( a_String )
			end
			# Assign the bits in self to be the bits in the given binary String
			def assign_binary_String( a_String )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_String ,String )
				# pure binary string checking
				assert( a_String.size == a_String.count( '01' ) ,'faulty implementation: an integer converted to a binary string did not produce just 0s and 1s.' )
				# convert to Bitset; this may or may not be the appropriate length, but dispatch will correct for that
				a_Bitset	= Bitset.from_s( a_String )
				# dispatch to new method
				self.assign_Bitset( a_Bitset )
			end
			# Assign the bits in self to be the bits in the given Asm::BCPU::Word
			def assign_BCPU_Word( a_BCPU_Word )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_BCPU_Word ,Asm::BCPU::Word )
				# dispatch to new method
				self.assign_Bitset( a_BCPU_Word.the_bits )
			end
			# Assign the bits in self to be the bits in the given Bitset
			#
			# Raises when input is invalid
			# Returns nothing
			def assign_Bitset( a_Bitset )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_Bitset ,Bitset )
				# content preservation checking
				assert( a_Bitset.size <= Asm::Magic::Memory::Bits_per::Word ,"The bitset contains more than "<<Asm::Magic::Memory::Bits_per::Word<<"bits; assigning it may lose information in an unintended way." )
				# make the assignment to @the_bits
				@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )	# 0000 0000 0000 0000
				self.bitwise_OR!( a_Bitset )	# 1s from a_Bitset will appear in @the_bits
				return
			end
		public
=begin		implementation details
=end
			# Bitset's bitwise-or (aka '|') is broken (in one usage case only), don't use it.
			# If for some reason you need that, then use this instead.
			#
			# Modifies self
			# Returns nothing
			def bitwise_OR!( an_Object )	# TODO verify this preserves size
				# switch case on type; fuck duck typing.
				if Asm::Boilerplate::true_if_type( an_Object ,Asm::Virtual_Machine::Word )
					@the_bits | an_Object.the_bits	# non broken usage case; Bitset instances are same size
				elsif Asm::Boilerplate::true_if_type( an_Object ,Bitset )
					assert( !(an_Object.size < @the_bits.size) , "implementation fault: Bitset's | operation is broken in the case you tried to use it in; ask for a workaround asap." )
					@the_bits | an_Object
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
			# computes the Integer representation of @the_bits
			#
			# force_twos_complement - T: forces interpretation of @the_bits as a twos complement encoded binary value
			# 	F: forces interpretation of @the_bits as an unsigned binary encoded value
			#
			# Raises if something really wierd happens
			# Returns Integer
			def to_i( force_twos_complement = true )
				result	= 0
				for index in 0..(Asm::Magic::Memory::Bits_per::Word - 1)
					result += @the_bits[index] * ( 2 ** index )
				end
				if force_twos_complement
					result	= (2 ** Asm::Magic::Memory::Bits_per::Word) - result
					assert( result < Asm::Magic::Binary::Twos_complement::Exclusive::Maximum , 'unexpected overflow when converting a binary string to an Integer; number too positive' )
					assert( Asm::Magic::Binary::Twos_complement::Exclusive::Minimum < result , 'unexpected overflow when converting a binary string to an Integer; number too negative' )
				else
					assert( result < Asm::Magic::Binary::Unsigned::Exclusive::Maximum , 'unexpected overflow when converting a binary string to an Integer; number too positive' )
					assert( Asm::Magic::Binary::Unsigned::Exclusive::Minimum < result , 'unexpected overflow when converting a binary string to an Integer; number too negative' )
				end
				result
			end
			# Performs addition given an object
			# delegates alot
			#
			# Raises on unrecognized input type
			def add!( an_Object ,force_twos_complement = true )
				if Asm::Boilerplate::true_if_type( an_Object ,Asm::BCPU::Word )
					self.add_Word!( an_Object ,force_twos_complement )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Asm::BCPU::Value )
					raise 'invalid invocation' unless force_twos_complement
					self.add_Value!( an_Object )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Asm::BCPU::Location )
					raise 'invalid invocation' unless !force_twos_complement
					self.add_Location!( an_Object )
				elsif Asm::Boilerplate::true_if_type( an_Object ,Integer )
					self.add_Integer!( an_Object ,force_twos_complement )
				else
					raise	'Chiiiii'
				end
			end
			# Performs addition given another Asm::BCPU::Word instance
			def add_Word!( rhs_BCPU_Word ,force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( rhs_BCPU_Word ,Asm::BCPU::Word )
				# utilize to_i to implement addition
				rhs	= rhs_BCPU_Word.to_i( force_twos_complement )
				self.add_Integer!( rhs ,force_twos_complement )
			end
			# Performs addition given another Asm::BCPU::Word instance
			def add_Value!( rhs_Memory_Value )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( rhs_Memory_Value ,Asm::BCPU::Memory::Value )
				# utilize to_i to implement addition
				rhs	= rhs_Memory_Value.to_i( )
				self.add_Integer!( rhs ,true )
			end
			# Performs addition given another Asm::BCPU::Word instance
			def add_Location!( rhs_memory_location ,force_twos_complement = true )
				# paranoid type checking
				Asm::Boilerplate::raise_unless_type( rhs_memory_location ,Asm::BCPU::Memory::Location )
				# utilize to_i to implement addition
				rhs	= rhs_memory_location.to_i( force_twos_complement )
				self.add_Integer!( rhs ,force_twos_complement )
			end
			# Performs addition given another Asm::BCPU::Word instance
			#
			# Raises Asm::Boilerplate::Exception::Overflow when overflow or other failure occurs
			# Returns nothing
			def add_Integer!( rhs_Integer ,force_twos_complement = true )
				# paranoid type checking
				# TODO force Integer compatible type
				# utilize to_i to implement addition
				lhs	= self.to_i( force_twos_complement )
				rhs	= rhs_Integer
				result	= lhs + rhs
				# assign will attempt to represent the result in 16 bits; failure indicates overflow
				begin
					self.assign( result ,force_twos_complement )
                #TODO: Else without rescue is useless according to:
                # $ ruby -wc thisFile.rb
				else
					self.assign( 0 )
					raise Asm::Boilerplate::Exception::Overflow.new( 'arithmetic failed; \'0\' assigned as result of arithmetic operation.' )
				end
				return
			end
		end
		# DOCIT
		module Memory
			# DOCIT
			class Location < Asm::BCPU::Word
				# initializing constructor
				# see Asm::BCPU::Word::initialize
				def initialize( an_Object = nil )
					self.assign( an_Object )
				end
				# Interprets self as the unsigned binary encoding of an integer value
				#
				# Returns an integer
				def to_i( )
					super( false )
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
				# Interprets self as the twos complement encoding of an integer value
				#
				# Returns an integer
				def to_i( )
					super( true )
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
        #class Test < Test::Unit::TestCase
        #end
    end
end

module Asm
    module Magic
        module Register
=begin		# Asm::Magic::Register::Location
			    * memory locations of unique special function registers
=end			
            module Location 
				Program_counter	= Asm::BCPU::Memory::Location.new( Asm::Magic::Register::Index::Program_counter )
            end
=begin      # Asm::Magic::Register::Locations
                * memory locations of ategories of special function registers
=end			
            module	Locations 
				Input_registers	 = Asm::Magic::Register::Indicies::Input_registers.each { |index| Asm::BCPU::Memory::Location.new( index ) }
				Output_registers = Asm::Magic::Register::Indicies::Output_registers.each { |index| Asm::BCPU::Memory::Location.new( index ) }
		    end
        end
    end
end

#require	'Asm/require_all.rb'
$LOAD_PATH << '.'
# encoding: UTF-8
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=ruby
