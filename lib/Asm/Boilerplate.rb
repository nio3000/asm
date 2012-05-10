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
					(8..11).each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_RA_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					(4..7).each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_RB_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					(0..3).each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					return result
				end
				# DOCIT
				def self.get_value_from_bit_range( a_Memory_Value ,a_bit_range )
					puts("Memory Value: " + a_Memory_Value.to_s)
					result = ::Asm::BCPU::Memory::Location.new
					puts("Results 1: " + result.to_s)
					a_bit_range.each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
						puts("" << result.the_bits[index].to_s << " = " << a_Memory_Value.the_bits[index].to_s)
					end
					puts("Results 2: " + result.to_s)
					return result
				end
				# DOCIT
				def self.get_value_from_bit_range__reversi( a_Memory_Value ,a_bit_range )
					result = ::Asm::BCPU::Memory::Location.new
					for index in a_bit_range
						to_index	= result.the_bits.size - 1 - index
						result.the_bits[to_index] = a_Memory_Value.the_bits[index]
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
			begin
				puts "(#{argument}) argument's type is #{argument.kind_of()}" << ', not ' << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '".' unless argument.instance_of?( type )
			rescue
				puts "(#{argument}) argument's type is not " << type.inspect() << '; argument.inspect gives "' << argument.inspect( ) << '". It is probably nil.' unless argument.instance_of?( type )
			end
			return
		end
=begin
		# Asm::Boilerplate::DEBUG
		* boilerplate from debugging
		* management of boilerplate from debugging
			* if it's not defined under this module, it isn't managed by this module.
=end
		module DEBUG
=begin
			# Asm::Boilerplate::DEBUG::Control
			* management of boilerplate from debugging
				* globally accessible bools to govern output
				* if your DEBUG boilerplate can be disabled without deleting the line of code, then put a bool for it here or use one of these.
=end
			module Control
=begin
				# Asm::Boilerplate::DEBUG::Control::Manner
				* governing the methods of DEBUG output
					* console ...
					* raise ::Asm::Boilerplate::Exception::DEBUG.new( ... )
=end
				module Manner
					Console = true	# allow managed methods to use puts or print
					Raise	= true	# allow managed methods to raise Asm::Boilerplate::Exception::DEBUG instances
				end
=begin
				# Asm::Boilerplate::DEBUG::Control::Concern
				* governing the content of DEBUG output for special concerns
					* GUI
					* Loader
					* VM
					* BCPU	# Asm::BCPU
					* Scope	# when are you where
=end
				module Concern
					GUI	= true
					Loader	= true
					VM	= true
					BCPU	= true
					Scope	= true
				end
			end
=begin
			# Asm::Boilerplate::DEBUG::Console
			* managed debug boilerplate that primarily uses the console to communicate information during execution
=end
			module Console
				# ::Asm::Boilerplate::DEBUG::Console.announce
				# code to get scope information from inside a method
				# * will print out the name of the method containing
				def self.announce( append_this_String = '' ,a_bool = true ,prepend_this_string = 'DEBUG: ' ,delim = ': ' )
					if a_bool && Asm::Boilerplate::DEBUG::Control::Manner::Console && Asm::Boilerplate::DEBUG::Control::Concern::Scope
						#output	= '' << prepend_this_string + caller[1][/`.*'/][1..-2]
						#output	= '' << prepend_this_string + caller.to_s
						#puts caller.to_s
						output	= '' << prepend_this_string + caller[0][/[a-zA-Z0-9 ]+.rb:[0-9]+/] + ' in ' + caller[0][/`.*'/][1..-2]
						if	!append_this_String.empty?
							output << delim << append_this_String
						end
						puts output
					end
				end
				# ::Asm::Boilerplate::DEBUG::Console.assert
				# code to notify if a condition is not met
				def self.assert( a_boolean ,a_message = 'undocumented' )
					if a_bool && Asm::Boilerplate::DEBUG::Control::Manner::Raise
						if	Asm::Boilerplate::DEBUG::Control::Concern::Scope
							::Asm::Boilerplate::DEBUG::Console.announce( a_message ,a_bool ,'ASSERT: ' )
						else
							puts a_message unless a_boolean
						end
					end
				end
			end
=begin
			# Asm::Boilerplate::DEBUG::Exception
			* managed debug boilerplate that primarily uses exceptions to communicate information during execution
=end
			module Exception
				# ::Asm::Boilerplate::DEBUG::Exception.assert
				# code to raise if a condition is not met
				# * will raise an exception of a given type
				# 	* default type for exceptions raised is `Asm::Boilerplate::Exception::DEBUG`
				# * if raises have been disallowed, then this will use console instead.
				def self.assert( a_boolean ,a_message = 'undocumented' ,an_exception_type = Asm::Boilerplate::Exception::DEBUG )
					if a_bool && Asm::Boilerplate::DEBUG::Control::Manner::Raise
						raise an_exception_type.new( a_message ) unless a_boolean
					elsif a_bool && Asm::Boilerplate::DEBUG::Control::Manner::Console
						::Asm::Boilerplate::DEBUG::Console.announce( a_message ,a_boolean ,'ASSERT: ' )
					end
				end
			end
		end
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
			class Asm::Boilerplate::Exception::DEBUG < ::Exception
			end
		end
	end
end
# encoding: UTF-8
