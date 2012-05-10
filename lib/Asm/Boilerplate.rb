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
					::Asm::Boilerplate::DEBUG::Console.announce( "RD_result:#{result.to_s}",::Asm::Boilerplate::DEBUG::Control::Concern::VM )
					return result
				end
				# DOCIT
				def self.get_RA_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					(4..7).each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					::Asm::Boilerplate::DEBUG::Console.announce( "RA_result:#{result.to_s}",::Asm::Boilerplate::DEBUG::Control::Concern::VM )
					return result
				end
				# DOCIT
				def self.get_RB_location( a_Memory_Value )
					result = ::Asm::BCPU::Memory::Location.new
					(0..3).each do |index|
						result.the_bits[index] = a_Memory_Value.the_bits[index]
					end
					::Asm::Boilerplate::DEBUG::Console.announce( "RB_result:#{result.to_s}",::Asm::Boilerplate::DEBUG::Control::Concern::VM )
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
					(a_bit_range).each do |index|
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
						* Lexical_casting	# when converting between types, don't lose information
					* Scope	# when are you where
=end
				module Concern
					GUI	= false
					Loader	= true
						Directive	= false
						Key_RD_RA	= true
						Key_RD_RA_RB	= true
						Key_RD_RA_lit	= true
						Key_RD_lit_RB	= true
						Key_RD_lit	= true
						Comment	= false
					VM	= true
						Instructions	= true
							AND		= true
							SUBI	= true
						Memory_operations	= false	# Virtual_Machine#get_memory_value ,Virtual_Machine#set_location_to_value ,Virtual_Machine#get_memory_range
					BCPU	= true	# related to BCPU::Word, BCPU::Memory::Location, or BCPU::Memory::Value
						Lexical_casting	= false	# uses thus far: BCPU::Word#to_i
					Scope	= true	# lifetime and where one is in the code in general
					Invalid_usage	= true
					Incorrect_results	= true
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
				def self.announce( append_this_String = '' ,a_bool = true ,prepend_this_string = 'DEBUG: ' ,levels_to_caller = 1 ,delim = ': ' )
					if a_bool && Asm::Boilerplate::DEBUG::Control::Manner::Console && Asm::Boilerplate::DEBUG::Control::Concern::Scope
						#output	= '' << prepend_this_string + caller[1][/`.*'/][1..-2]
						#output	= '' << prepend_this_string + caller.to_s
						#puts caller.to_s
						output	= '' << prepend_this_string + Asm::Boilerplate::DEBUG::String.report_caller( levels_to_caller )
						if	!append_this_String.empty?
							output << delim << append_this_String
						end
						puts output
					end
				end
				# ::Asm::Boilerplate::DEBUG::Console.assert
				# code to notify if a condition is not met
				def self.assert( the_result_of_the_test ,a_message = 'undocumented' ,a_boolean = true ,levels_to_caller = 1  )
					if !the_result_of_the_test && Asm::Boilerplate::DEBUG::Control::Manner::Raise && a_boolean
						if	Asm::Boilerplate::DEBUG::Control::Concern::Scope
							::Asm::Boilerplate::DEBUG::Console.announce( a_message ,a_boolean ,'ASSERT: ' ,levels_to_caller + 1 )
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
				def self.assert( the_result_of_the_test ,a_message = 'undocumented' ,a_boolean = true ,levels_to_caller = 1 ,an_exception_type = Asm::Boilerplate::Exception::DEBUG )
					::Asm::Boilerplate::DEBUG::Console.assert( the_result_of_the_test ,a_message ,a_boolean ,levels_to_caller + 1 )
					if Asm::Boilerplate::DEBUG::Control::Manner::Raise && a_boolean
						raise an_exception_type.new( a_message ) unless the_result_of_the_test
					end
				end
			end
			module String
				# DOCIT
				def self.report_caller( index = 0 )
					return	caller[index][/[a-zA-Z0-9 _.]+.rb:[0-9]+/] + ' in ' + caller[index][/`.*'/][1..-2]
				end
				# DOCIT
				# Deprecated, use "#{an_Integer}" instead.
				def self.report_an_Integer( an_Integer ,prepend_this_String = 'an_Integer = ' ,append_this_String = '' )
					begin
						if an_Integer.integer?
							return	'' << prepend_this_String << an_Integer.to_s << append_this_String
						else
							return	'' << prepend_this_String << an_Integer.to_i.to_s << append_this_String
						end
					rescue
						Asm::Boilerplate::DEBUG::Exception.assert( false ,'the type of the argument is disagreable OR to_s and to_i methods may have thrown.' )
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
=begin
# DOCIT
=end
module	::Asm::Magic
=begin
	# DOCIT
=end
	module	Memory::Index
		# DOCIT
		def	self.assert_valid( an_Integer )
			::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer.integer? ,'argument is not an integer incompatible type' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
			text	= "(#{::Asm::Magic::Memory::Index::Exclusive::Minimum} < #{an_Integer} < #{::Asm::Magic::Memory::Index::Exclusive::Maximum}) == false -> invalid memory index"
			::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer < ::Asm::Magic::Memory::Index::Exclusive::Maximum ,text ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
			::Asm::Boilerplate::DEBUG::Exception.assert( ::Asm::Magic::Memory::Index::Exclusive::Minimum < an_Integer ,text,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
			return
		end
	end
=begin
	# DOCIT
=end
	module	Binary
		module	Twos_complement
			# twos complement range checking
			def	self.assert_valid( an_Integer )
				::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer.integer? ,'argument is not an integer incompatible type' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				text	= "(#{::Asm::Magic::Binary::Twos_complement::Exclusive::Minimum} < #{an_Integer} < #{::Asm::Magic::Binary::Twos_complement::Exclusive::Maximum}) == false -> invalid twos complement number on #{Asm::Magic::Memory::Bits_per::Word} bits"
				::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer < ::Asm::Magic::Binary::Twos_complement::Exclusive::Maximum ,text ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				::Asm::Boilerplate::DEBUG::Exception.assert( ::Asm::Magic::Binary::Twos_complement::Exclusive::Minimum < an_Integer ,text,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				return
			end
		end
		module	Unsigned
			# unsigned binary range checking
			def	self.assert_valid( an_Integer )
				::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer.integer? ,'argument is not an integer incompatible type' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				text	= "(#{::Asm::Magic::Binary::Unsigned::Exclusive::Minimum} < #{an_Integer} < #{::Asm::Magic::Binary::Unsigned::Exclusive::Maximum}) == false -> invalid unsigned binary on #{Asm::Magic::Memory::Bits_per::Word} bits"
				::Asm::Boilerplate::DEBUG::Exception.assert( an_Integer < ::Asm::Magic::Binary::Unsigned::Exclusive::Maximum ,text ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				::Asm::Boilerplate::DEBUG::Exception.assert( ::Asm::Magic::Binary::Unsigned::Exclusive::Minimum < an_Integer ,text,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				return
			end
		end
		module	String
			# raise if there is evidence that the given string is not a binary string.
			def	self.assert_valid( a_String )
				::Asm::Boilerplate::DEBUG::Exception.assert( a_String.instance_of?( ::String ),'argument is not an instance of ::String' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				::Asm::Boilerplate::DEBUG::Exception.assert( Asm::Magic::Binary::String::valid?( a_String ) ,"#{a_String} is not a binary string" ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				return
			end
		end
		module	Bitset
			# raise if there is evidence that the given string is not a binary string.
			def	self.assert_valid( a_Bitset )
				::Asm::Boilerplate::DEBUG::Exception.assert( a_Bitset.instance_of?( ::Bitset ),'argument is not an instance of ::Bitset' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				::Asm::Boilerplate::DEBUG::Exception.assert( Asm::Magic::Binary::Bitset::valid?( a_Bitset ),"#{a_Bitset.to_s} contains more than #{Asm::Magic::Memory::Bits_per::Word} bits; it won't play nice with bitset from Asm::BCPU::Word and derived classes." ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
				return
			end
		end
	end
	module	Base10::String
		# raise if there is evidence that the given string is not a base 10 string of digits.
		def	self.assert_valid( a_String )
			::Asm::Boilerplate::DEBUG::Exception.assert( a_String.instance_of?( ::String ),'argument is not an instance of ::String' ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
			::Asm::Boilerplate::DEBUG::Exception.assert( Asm::Magic::Base10::String::valid?( a_String ) ,"#{a_String} is not a decimal (base 10) string" ,::Asm::Boilerplate::DEBUG::Control::Concern::Invalid_usage ,2 )
			return
		end
	end
	module	Loader::Load::Index
		# raise unless the given load index is in a valid state
		def self.assert_valid( an_Integer )
			::Asm::Magic::Binary::Unsigned.assert_valid( an_Integer )
			return
		end
	end
end
# encoding: UTF-8
