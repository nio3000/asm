=begin
# /lib/Asm/BCPU.rb
* complete definition of class Asm::BCPU::Word and inheritors
	Asm::BCPU::Memory::Location and Asm::BCPU::Memory::Value
* isloated helper methods under modules
	Asm::BCPU::Memory::Index and Asm::BCPU::Register
* unit tests on instances of Asm::BCPU::Word,Asm::BCPU::Memory::Location,
	and Asm::BCPU::Memory::Value
* largely undocumented and unimplemented
=end

# DOCIT
module Asm::BCPU
=begin
	# Asm::BCPU::Word
	* a Word is the fundamental data type in the BCPU
	* Asm::BCPU::Memory::Location inherits from Asm::BCPU::Word
	* memory locations have a subtly different context for
		assignment operations (no two's complement)
	* Asm::BCPU::Memory::Value inherits from Asm::BCPU::Word
=end
	class Asm::BCPU::Word
	public
=begin
		structors & accessors
		* the instance variable @the_bits is a Bitset
		* see the repo for Bitset for details & methods available if you need to get at indivudal bits in the Bitset
=end
		# get @the_bits
		attr_accessor :the_bits
		# initializing constructor, implicitly default constructor
		# argument - see Asm::BCPU::Word::assign for restrictions
		# force_twos_complement - see Asm::BCPU::Word::assign for usage
		def initialize( an_Object = nil ,force_twos_complement = false ,force_unsigned = false )
			self.assign( an_Object ,force_twos_complement ,force_unsigned )
			self.assert_valid
		end
		# Creates a new instance of Asm::BCPU::Word,
		# initialized to the values in self
		# const copy constructor
		def clone
			return	Asm::BCPU::Word.new( self.the_bits )
		end
		# DOCIT
		def self.from_binary_String( a_binary_String )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_binary_String( a_binary_String )
			return	result
		end
		# DOCIT
		def self.from_decimal_String( a_decimal_String )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_decimal_String( a_decimal_String )
			return	result
		end
		# DOCIT
		def self.from_integer( an_Integer )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_integer( an_Integer )
			return	result
		end
		# DOCIT
		def self.from_integer_as_unsigned( an_Integer )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_integer_as_unsigned( an_Integer )
			return	result
		end
		# DOCIT
		def self.from_integer_as_twos_complement( an_Integer )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_integer_as_twos_complement( an_Integer )
			return	result
		end
		# DOCIT
		def self.from_Bitset( a_Bitset )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_Bitset( a_Bitset )
			return	result
		end
		# DOCIT
		def self.from_BCPU_Word( a_Word )
			# TODO Paranoid type checking
			result	= ::Asm::BCPU::Word.new
			raise ' Aya' unless result.instance_of? ::Asm::BCPU::Word
			result.assign_Word( a_Word )
			return	result
		end
	public
=begin
		implementation details, assignment
=end
		# Assign the bits in self to be the bits represented by the given object.
		# dispatches to type-specific assign methods, see those methods for constraints & behavior
		# an_Object - String, Integer-compatible, Bitset, or Asm::BCPU::Word
		# force_twos_complement - T: whenever possible,
		# force the encoding choice to be twos complement.
		# Raises when input is invalid
		# Returns nothing
		def assign( an_Object = nil ,force_twos_complement = false ,force_unsigned = false )
			if an_Object == nil	# Bitset initialized to 16 bits of zeros.
				@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )
			elsif an_Object.instance_of?( ::String )
				self.assign_String( an_Object ,force_twos_complement )
			# TODO double check that this catches all integer compatible types
			elsif an_Object.instance_of?( ::Bitset )
				self.assign_Bitset( an_Object )
			elsif an_Object.instance_of?( ::Asm::BCPU::Word )
				self.assign_BCPU_Word( an_Object )
			elsif an_Object.integer?	#an_Object.integer?
				self.assign_integer( an_Object ,force_twos_complement ,force_unsigned )
			else
				raise 'Waku waku!'
			end
		end
		# Assign the bits in self to be number represented in the String;
		# supports signed decimal integers (+|-)?[0-9] and binary [01]+
		# Raises when it cannot validly make an assumption about the string.
		def assign_String( a_String ,force_twos_complement = true )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( a_String ,String )
			# harvest evidence
			evidence_against_binary	= ! Asm::Magic::Binary::String::valid?( a_String )
			evidence_against_decimal	= ! Asm::Magic::Base10::String::valid?( a_String )
			# delegation
			if evidence_against_binary && !evidence_against_decimal
				self.assign_decimal_String( a_String ,force_twos_complement )
			elsif !evidence_against_binary && evidence_against_decimal
				self.assign_binary_String( a_String )
			elsif evidence_against_binary && evidence_against_decimal
				raise '\'' << a_String << '\' is not a decimal or a binary string'
			else	# elsif !evidence_against_binary && !evidence_against_decimal
				raise '\'' << a_String << '\' could be either a decimal or a binary string; Asm::BCPU::Word#assign_String cannot delegate validly.'
			end
		end
		# Assign the bits in self to be the binary representation of decimal value in the given String
		def assign_decimal_String( a_String ,force_twos_complement = true )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( a_String ,String )
			# pure decimal string checking
			Asm::Magic::Base10::String.assert_valid( a_String )
			# convert to Integer
			an_Integer	= a_String.to_i( 10 )
			# dispatch to new method
			self.assign_integer( an_Integer ,force_twos_complement )
		end
		# Assign the bits in self to be the binary representation of the given integer
		#
		# force_twos_complement
		#	T: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement
		#	F: will delegate assignment to Asm::BCPU::Word::assign_integer_as_twos_complement iff an_Integer < 0; else will delegate assignment to Asm::BCPU::Word::assign_integer_as_unsigned
		def assign_integer( an_Integer ,force_twos_complement = false ,force_unsigned = false )
			# DOCIT
			if	!(force_twos_complement == !force_unsigned)
				if	force_twos_complement == true
					raise 'Aya' 
				end
			end
			# paranoid type checking
			raise 'argument is not an integer' unless an_Integer.integer?
			# loose range checking based on known binary encodings (unsigned union twos-complement)
			# TODO maybe; refactor range checking from other assign_integer_as_... methods into boilerplate or magic; reuse
			# delegate to new method
			if force_twos_complement
				Asm::Magic::Binary::Twos_complement.assert_valid( an_Integer )
				self.assign_integer_as_twos_complement( an_Integer )
			elsif force_unsigned
				Asm::Magic::Binary::Unsigned.assert_valid( an_Integer )
				self.assign_integer_as_unsigned( an_Integer )
			else
				if Asm::Magic::Binary::Unsigned::valid?( an_Integer )
					self.assign_integer_as_unsigned( an_Integer )
				elsif Asm::Magic::Binary::Twos_complement::valid?( an_Integer )
					self.assign_integer_as_twos_complement( an_Integer )
				else
					raise "argument to Asm::BCPU::Word#assign_integer was of integer type was out of range."
				end
			end
		end
		# Assign the bits in self to be the twos_complement representation of the given integer
		def assign_integer_as_twos_complement( an_Integer )
			# paranoid type checking
			raise 'argument is not an integer' unless an_Integer.integer?
			# twos complement range checking
			Asm::Magic::Binary::Twos_complement.assert_valid( an_Integer )
			# convert to binary String twos complement encoding
			a_String	= '' << ::Asm::Boilerplate.get_sign_bit_as_String( an_Integer ) << ::Asm::Boilerplate.get_twos_complement_bits_as_String( an_Integer )
			Asm::Magic::Binary::String.assert_valid( a_String )
			# dispatch to new method
			self.assign_binary_String( a_String )
		end
		# Assign the bits in self to be the unsigned binary representation of the given integer
		def assign_integer_as_unsigned( an_Integer )
			# paranoid type checking
			raise 'argument is not an integer' unless an_Integer.integer?
			# unsigned range checking
			Asm::Magic::Binary::Unsigned.assert_valid( an_Integer )
			# convert to binary String unsigned binary encoding
			a_String	= an_Integer.to_s( 2 )
			Asm::Magic::Binary::String.assert_valid( a_String )
			# dispatch to new method
			self.assign_binary_String( a_String )
		end
		# Assign the bits in self to be the bits in the given binary String
		def assign_binary_String( a_String )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( a_String ,String )
			# pure binary string checking
			Asm::Magic::Binary::String.assert_valid( a_String )
			# convert to Bitset
			a_Bitset	= Bitset.from_s( a_String.rjust( ::Asm::Magic::Memory::Bits_per::Word ,'0' ) )
			# dispatch to new method
			self.assign_Bitset( a_Bitset )
		end
		# Assign the bits in self to be the bits in the given Asm::BCPU::Word
		def assign_BCPU_Word( a_BCPU_Word )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type(a_BCPU_Word,Asm::BCPU::Word)
			# dispatch to new method
			self.assign_Bitset( a_BCPU_Word.the_bits )
		end
		# Assign the bits in self to be the bits in the given Bitset
		#
		# Raises when input is invalid
		# Returns nothing
		def assign_Bitset( a_Bitset )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( a_Bitset ,Bitset )
			# content preservation checking
			Asm::Magic::Binary::Bitset.assert_valid( a_Bitset )
			# make the assignment to @the_bits
			@the_bits	= Bitset.new( Asm::Magic::Memory::Bits_per::Word )	# 0000 0000 0000 0000
			self.bitwise_OR!( a_Bitset )	# 1s from a_Bitset will appear in @the_bits
			self.assert_valid
			return
		end
	public
=begin
		implementation details
=end
		# DOCIT
		def	valid?
			@the_bits.size == ::Asm::Magic::Memory::Bits_per::Word
		end
		# DOCIT
		def	assert_valid
			raise 'Invalid ::Asm::BCPU::Word instance' unless self.valid?
		end
		# Bitset's bitwise-or (aka '|') is broken (in one usage case only), don't use it.
		# If for some reason you need that, then use this instead.
		#
		# Modifies self
		# Returns nothing
		def bitwise_OR!( an_Object )	# TODO verify this preserves size
			# switch case on type; fuck duck typing.
			if an_Object.instance_of?( ::Asm::BCPU::Word )
				@the_bits	= @the_bits | an_Object.the_bits	# non broken usage case; Bitset instances are same size
			elsif an_Object.instance_of?( ::Bitset )
				if an_Object.size < @the_bits.size
					raise 'implementation fault: Bitset\'s | operation is broken in the case you tried to use it in; ask for a workaround asap.'
					for index in (0..an_Object.size - 1)
						# TODO this code needs adjustment maybe?, but other code should be avoiding this section now. . .maybe
						@the_bits[index]	= @the_bits[index] |  an_Object[index]
					end
				else
					@the_bits	= @the_bits | an_Object
				end
			else
				raise 'Ojou-sama, that is inappropriate.'
			end
			self.assert_valid
			return
		end
		# Obtain a binary String of the bits in self
		def to_s
			result	= @the_bits.to_s
			self.assert_valid
			return	result
		end
		# computes the Integer representation of @the_bits
		#
		# force_twos_complement - T: forces interpretation of @the_bits as a twos complement encoded binary value
		#	F: forces interpretation of @the_bits as an unsigned binary encoded value
		#
		# Raises if something really wierd happens
		# Returns Integer
		def to_i( force_twos_complement = true ,force_unsigned = false )
			# DOCIT
			if	!(force_twos_complement == !force_unsigned)
				if	force_twos_complement == true
					raise 'Aya' 
				end
			end
			#
			result	= 0
			a_String	= @the_bits.to_s
			#a_bits = the_bits
			for index in 0..(Asm::Magic::Memory::Bits_per::Word - 1)
				exponent	= (Asm::Magic::Memory::Bits_per::Word - 1) - index
				result	+= a_String[index].to_s.to_i( 2 ) * ( 2 ** exponent )
			end
			Asm::Magic::Binary::Unsigned.assert_valid( result )
			if force_twos_complement
				#result	= (2 ** Asm::Magic::Memory::Bits_per::Word) - result + 1
				result	= - result + 1
				Asm::Magic::Binary::Twos_complement.assert_valid( result )
				#assert( result < Asm::Magic::Binary::Twos_complement::Exclusive::Maximum , 'unexpected overflow when converting a binary string to an Integer; number too positive' )
				#assert( Asm::Magic::Binary::Twos_complement::Exclusive::Minimum < result , 'unexpected overflow when converting a binary string to an Integer; number too negative' )
			elsif force_unsigned
				Asm::Magic::Binary::Unsigned.assert_valid( result )
				raise 'shenanigans' << @the_bits.to_s.to_i( 2 ).to_s << '==' << result.to_s unless @the_bits.to_s.to_i( 2 ) == result
				#assert( result < Asm::Magic::Binary::Unsigned::Exclusive::Maximum , 'unexpected overflow when converting a binary string to an Integer; number too positive' )
				#assert( Asm::Magic::Binary::Unsigned::Exclusive::Minimum < result , 'unexpected overflow when converting a binary string to an Integer; number too negative' )
			else
				if	!Asm::Magic::Binary::Unsigned.valid?( result )
					result	= - result + 1
				end
			end
			result
		end
		# DOCIT
		def from_i( an_Integer ,force_twos_complement = true )
			raise 'deprecated method ::Asm::BCPU::Word#from_i; use ::Asm::BCPU::Word.from_integer or variants instead'
			# Paranoid type checking
			raise "you passed a noninteger to Asm::BCPU::Word#from_i; don't do that!" unless  an_Integer.integer?
			if	force_twos_complement | ::Asm::Magic::Binary::Twos_complement.valid?( an_Integer )
				::Asm::Magic::Binary::Twos_complement.assert_valid( an_Integer )
				#a_binary_String	= '' << ::Asm::Boilerplate.get_sign_bit_as_String( an_Integer ) << ::Asm::Boilerplate.get_twos_complement_bits_as_String( an_Integer )
				a_binary_String	= '' << ::Asm::Boilerplate.get_twos_complement_bits_as_String( an_Integer ) << ::Asm::Boilerplate.get_sign_bit_as_String( an_Integer )
				self.assign_binary_String( a_binary_String )
			else
				::Asm::Magic::Binary::Unsigned.assert_valid( an_Integer )
				self.assign_binary_String( an_Integer.to_s( 2 ) )
			end
			return
		end
		# Performs addition given an object
		# delegates alot
		#
		# Raises on unrecognized input type
		def add!( an_Object ,force_twos_complement = true )
			if an_Object.instance_of?( ::Asm::BCPU::Word )
				self.add_Word!( an_Object ,force_twos_complement )
			#elsif an_Object.instance_of?( ::Asm::BCPU::Memory::Value )
			#	raise 'invalid invocation' unless force_twos_complement
			#	self.add_Value!( an_Object )
			elsif an_Object.instance_of?( ::Asm::BCPU::Memory::Location )
				raise 'invalid invocation' unless !force_twos_complement
				self.add_Location!( an_Object )
			elsif an_Object.integer?
				self.add_Integer!( an_Object ,force_twos_complement )
			else
				raise	'Chiiiii'
			end
		end
		# Performs addition given another Asm::BCPU::Word instance
		def add_Word!( rhs_BCPU_Word ,force_twos_complement = true )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( rhs_BCPU_Word ,Asm::BCPU::Word )
			# utilize to_i to implement addition
			rhs	= rhs_BCPU_Word.to_i( force_twos_complement )
			self.add_Integer!( rhs ,force_twos_complement )
		end
		# Performs addition given another Asm::BCPU::Word instance
		#def add_Value!( rhs_Memory_Value )
		#	# paranoid type checking
		#	Asm::Boilerplate.raise_unless_type( rhs_Memory_Value ,Asm::BCPU::Memory::Value )
		#	# utilize to_i to implement addition
		#	rhs	= rhs_Memory_Value.to_i( )
		#	self.add_Integer!( rhs ,true )
		#end
		# Performs addition given another Asm::BCPU::Word instance
		def add_Location!( rhs_memory_location ,force_twos_complement = true )
			# paranoid type checking
			Asm::Boilerplate.raise_unless_type( rhs_memory_location ,Asm::BCPU::Memory::Location )
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
			#lhs	= self.to_i( force_twos_complement )
			lhs	= self.to_i()
			rhs	= rhs_Integer
			result	= lhs + rhs
			# assign will attempt to represent the result in 16 bits; failure indicates overflow
			begin
				self.assign( result ,force_twos_complement )
			#TODO: Else without rescue is useless according to:
			# $ ruby -wc thisFile.rb
			rescue
			else
				self.assign( 0 )
				raise Asm::Boilerplate::Exception::Overflow.new( "arithmetic failed; '0' assigned as result of arithmetic operation." )
			end
			return
		end
	end
	# DOCIT
	module Asm::BCPU::Memory
		# DOCIT
		class Asm::BCPU::Memory::Location < Asm::BCPU::Word
			# initializing constructor
			# see Asm::BCPU::Word::initialize
			def initialize( an_Object = nil )
				super( an_Object ,false ,true )
			end
			# Interprets self as the unsigned binary encoding of an integer value
			#
			# Returns an integer
			def to_i( )
				super( false ,true )
			end
			# DOCIT
			def less_than?( rhs )
				if rhs.instance_of?( ::Asm::Virtual_Machine::Memory_Location )
					return	self.to_i( ) < rhs.to_i( )
				elsif rhs.integer?
					return	self.to_i( ) < rhs
				else
					raise "wtf; stop it"
					# TODO reduce exception boilerplate
				end
			end
			# DOCIT
			def equal_to?( rhs )
				if rhs.instance_of?( ::Asm::BCPU::Memory::Location )
					return	self.to_i( ).equal?( rhs.to_i( ) )
				elsif rhs.integer?
					return	self.to_i( ).equal?( rhs )
				else
					raise "wtf; stop it"
					# TODO reduce exception boilerplate
				end
			end
			# DOCIT
			def valid?
				return	Asm::Magic::Memory::Index::valid?( self.to_i( ) )
			end
			# DOCIT
			def self.from_binary_String( a_binary_String )
				# TODO Paranoid type checking
				result	= self.class.new
				result.assign_binary_String( a_binary_String )
				return	result
			end
			# DOCIT
			def self.from_decimal_String( a_decimal_String )
				# TODO Paranoid type checking
				result	= self.class.new
				result.assign_decimal_String( a_decimal_String )
				return	result
			end
			# DOCIT
			def self.from_integer( an_Integer )
				# TODO Paranoid type checking
				result	= self.class.new
				result.assign_integer( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_integer_as_unsigned( an_Integer )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Location.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Location
				result.assign_integer_as_unsigned( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_integer_as_twos_complement( an_Integer )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Location.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Location
				result.assign_integer_as_twos_complement( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_Bitset( a_Bitset )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Location.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Location
				result.assign_Bitset( a_Bitset )
				return	result
			end
			# DOCIT
			def self.from_BCPU_Word( a_Word )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Location.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Location
				result.assign_Word( a_Word )
				return	result
			end
		end
		# DOCIT
		class Asm::BCPU::Memory::Value < Asm::BCPU::Word
			# initializing constructor
			# see Asm::BCPU::Word::initialize
			def initialize( an_Object = nil )
				super( an_Object ,true )
			end
			# Interprets self as the twos complement encoding of an integer value
			#
			# Returns an integer
			def to_i( )
				super( false ,false )
			end
			# DOCIT
			def self.from_binary_String( a_binary_String )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_binary_String( a_binary_String )
				return	result
			end
			# DOCIT
			def self.from_decimal_String( a_decimal_String )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_decimal_String( a_decimal_String )
				return	result
			end
			# DOCIT
			def self.from_integer( an_Integer )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_integer( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_integer_as_unsigned( an_Integer )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_integer_as_unsigned( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_integer_as_twos_complement( an_Integer )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_integer_as_twos_complement( an_Integer )
				return	result
			end
			# DOCIT
			def self.from_Bitset( a_Bitset )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_Bitset( a_Bitset )
				return	result
			end
			# DOCIT
			def self.from_BCPU_Word( a_Word )
				# TODO Paranoid type checking
				result	= ::Asm::BCPU::Memory::Value.new
				raise ' Aya' unless result.instance_of? ::Asm::BCPU::Memory::Value
				result.assign_Word( a_Word )
				return	result
			end
		end
	end
end

=begin
	# Asm::Magic::Register::Location
	* memory locations of unique special function registers
=end
module Asm::Magic::Register::Location
	Minimum	= Asm::BCPU::Memory::Location.from_integer_as_unsigned( Asm::Magic::Register::Index::Inclusive::Minimum )
	Maximum	= Asm::BCPU::Memory::Location.from_integer_as_unsigned( Asm::Magic::Register::Index::Inclusive::Maximum )
	Program_counter	= Asm::BCPU::Memory::Location.from_integer_as_unsigned( Asm::Magic::Register::Index::Program_counter )
end
=begin
	# Asm::Magic::Register::Locations
	* memory locations of ategories of special function registers
=end
module	Asm::Magic::Register::Locations
	Input_registers	 = Asm::Magic::Register::Indicies::Input_registers.each { |index| Asm::BCPU::Memory::Location.from_integer_as_unsigned( index ) }
	Output_registers = Asm::Magic::Register::Indicies::Output_registers.each { |index| Asm::BCPU::Memory::Location.from_integer_as_unsigned( index ) }
end

# encoding: UTF-8
