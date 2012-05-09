=begin
# /lib/Asm/Boilerplate.rb
* refactored boilerplate code living under module Asm::Boilerplate
=end

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin
	# Asm::Boilerplate
=end
	module Asm::Boilerplate
		def self.bool_to_s( memory_bit )
			if memory_bit
				return "1"
			else
				return "0"
			end
		end

		module Machine
			module Code
				# DOCIT
				def self.get_OPcode_as_string( a_Memory_Value )
					return "" + Asm::Boilerplate.bool_to_s(a_Memory_Value.the_bits[15]) + Asm::Boilerplate.bool_to_s(a_Memory_Value.the_bits[14]) + Asm::Boilerplate.bool_to_s(a_Memory_Value.the_bits[13]) + Asm::Boilerplate.bool_to_s(a_Memory_Value.the_bits[12])
				end
				# DOCIT
				def self.get_RD_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					for index in (8..11)
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_RA_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					for index in (4..7)
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_RB_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					for index in (0..3)
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_value_from_bit_range( a_Memory_Value ,a_bit_range )
					result = ::Asm::BCPU::Memory::Location.new
					for index in a_bit_range
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
			end
		end
		# DOCIT
		def	self.get_sign_bit_as_String( an_Integer )
			# Paranoid type checking
			raise "you passed a noninteger to Asm::Boilerplate.get_sign_bit_as_String; don't do that!" unless  an_Integer.integer?
			if	an_Integer.instance_of? ::Fixnum
				index_of_sign_bit	= (an_Integer.size * ::Asm::Magic::Memory::Bits_per::Byte) - 1
				result	= an_Integer[index_of_sign_bit].to_s( 2 )
				raise 'shenanigans and sharnigans!' unless ((result.size == 1) && (result.count('01') == 1))
				return	result
			else
				raise 'shenanigans! unsupported type'
			end
		end
		# DOCIT
		def	self.get_twos_complement_bits_as_String( an_Integer )
			# Paranoid type checking
			raise "you passed a noninteger to Asm::Boilerplate.get_twos_complement_bits_as_String; don't do that!" unless  an_Integer.integer?
			if	an_Integer.instance_of? ::Fixnum
				a_binary_String	= ''

				(0..(::Asm::Magic::Memory::Bits_per::Word - 1 - 1)).each do |index|
					#a_binary_String << an_Integer[index].to_s( 2 )
					a_binary_String	= an_Integer[index].to_s( 2 ) << a_binary_String
				end
				raise 'shenanigans and sharnigans!' unless ( a_binary_String.size == a_binary_String.count('01') )
				return	a_binary_String
			else
				raise 'shenanigans! unsupported type'
			end
		end
		# DOCIT
		# strings got padded, this is a hotfix
		def	self.pads!( a_Range )
			offset	= (::Asm::Magic::Memory::Bits_per::Word - 1)
			return	(offset - a_Range.last)..(offset - a_Range.first)
		end
		# DOCIT
		# strings got padded, this is a hotfix
		def	self.socks!( a_Range ,index )
			offset	= (a_Range.last - a_Range.first) - 2 * index
			return	a_Range.first( index + 1 )[index]
		end
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Rasies exception when the check fails.
		# Returns nothing.
		def	self.raise_unless_type( argument ,type )
			#raise "argument's type is " << argument.kind?() << ", not " << type.inspect() << "." unless argument.kind? == type
			begin
				raise "(#{argument}) argument's type is " << argument.kind_of() << ', not ' << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '". It is probably nil.' unless argument.instance_of?( type )
			end
			return
		end
		def	self.puts_unless_type( argument ,type )
			#raise "argument's type is " << argument.kind?() << ", not " << type.inspect() << "." unless argument.kind? == type
			begin
				puts "(#{argument}) argument's type is " << argument.kind_of() << ', not ' << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '". It is probably nil.' unless argument.instance_of?( type )
			end
			return
		end
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Returns true iff arugment is of type type.
		#def	self.true_if_type( argument ,type )
		#	return	argument.kind_of? type
		#end
=begin
		# Asm::Boilerplate::Bitset
=end
		#module Asm::Boilerplate::Bitset
			# boilerplate for resizing an instance of Bitset
			#self.def	resize( a_Bitset ,desired_size )
				# TODO implement this
			#end
		#end
=begin
		# Asm::Boilerplate::Exception
=end
		class Asm::Boilerplate::Exception
=begin
		# Asm::Boilerplate::Exception::Syntax
		* if code generates a BCPU assembly syntax error,
			then raise an exception of this type with a message explaining the error
		* you don't need to add line number information,
			that happens when the Syntax object is rescued
		* example: `raise Asm::Boilerplate::Exception::Syntax.new( 'gibberish input; not an instruction, directive, comment, or blank line.' )`
=end
			class Asm::Boilerplate::Exception::Syntax < ::Exception
			end
=begin
			# Asm::Boilerplate::Exception::Overflow
			* DOCIT
=end
			class Asm::Boilerplate::Exception::Overflow < ::Exception
			end
			class Asm::Boilerplate::Exception::Misaka_Mikoto < ::Exception
			end
		end
	end
end

# encoding: UTF-8
