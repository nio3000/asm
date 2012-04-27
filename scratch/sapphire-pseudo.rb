#!/usr/bin/ruby
# Internal: Create a Regexp instance that will named-capture any literal's flag & value.
#
# flag_capture_name  - matched literal's flag's capture name.
# value_capture_name - matched literal's value's capture name.
#
# Examples
#
#   literal_named_capture_Regexp( 'Miku' ,'Chado' ).match( '0b0' )['Miku']
#   # => '0b'
#
# Returns the created Regexp instance.
def	literal_named_capture_Regexp( flag_capture_name ,value_capture_name )
	#  strings storing regexs for flags & values of relevant literals
	any_binary_flag	= '0[bB]'
	any_binary_value	= '[01]+'
	any_decimal_flag	= '[dD]{,1}'
	any_decimal_value	= '[\+\-]{,1}[0-9]+'
	any_register_flag	= '[rR]'
	any_register_value	= '[0-9]+'
	# organization
	binary	= { 'flag' => any_binary_flag ,'value' => any_binary_value }
	decimal	= { 'flag' => any_decimal_flag ,'value' => any_decimal_value }
	register	= { 'flag' => any_register_flag ,'value' => any_register_value }
	# further organization
	tohru_honda	= 0
	regex_text	= ''
	[binary ,decimal ,register].each do |type|
		##puts type
		regex_text << ((tohru_honda > 0)?('|'):('')) << '((?<' << flag_capture_name << '>' << (type['flag']) << ')(?<' << value_capture_name << '>' << (type['value']) << '))'
		tohru_honda += 1
	end
	return	Regexp.new( regex_text )
end

# inline testing because the Loader object isn't designed yet. . . 
['0b0000000000000000000000000000000000000000000001' ,"dddddd0b01" ,"R9989" ,"d12" ,"1111"].each do |text|
	result	= literal_named_capture_Regexp( 'mai_flag' ,'mai_value' ).match( text )
	puts	'text: ' << text
	unless	result.nil?
		puts	'flag: ' << result['mai_flag']
		puts	'value: ' << result['mai_value']
	else
		puts	'no match; not a literal'
	end
end












### hahahahahaha
# ...
module	Type
	# ...
	module	BCPU
		# ...
		#
		# Raises exception when argument does not translate to a valid BCPU word
		# Returns a new BCPU word
		def Word( argument )
			# Bitset initialized to 16 bits of zeros.
			result	= Bitset.new( Asm::Literals_Are_Magic::Memory::bits_per_word )
			# using argument to set the bits
			if Asm::Boilerplate::true_if_type( argument ,String )
				# TODO implement this
				# convert decimal literals
				# convert binary literals 
				raise "hahaha"
			else if Asm::Boilerplate::true_if_type( argument ,Integer )
				# convert Integers
				binary_value	= argument.to_s( )
				# TODO binary_value needs clean up; if Integer was < 0, then the formatting is wonky (see String's ruby docs), else it's probably fine
					# psst, abs( argument ) makes it positive; but you still need to set the sign bit and make sure its in the valid range for negative & twos complement
				partial_result	= Bitset.from_s( binary_value )
				result	= result | partial_result
			end
			return	result
		end
		# strict type checking
		#
		# Returns true if argument is a BCPU word
		def Word?( argument )
			return	Asm::Boilerplate::true_if_type( argument ,Bitset ) && ( argument.size == Asm::Literals_Are_Magic::Memory::bits_per_word )
		end
	end
	# ...
	module	Memory
		# strict type checking
		#
		# Returns true if argument is a memory value
		def Value?( argument )
			return	Asm::Literals_Are_Magic::Type::BCPU::Word?( argument )
		end
		# strict type checking
		#
		# Returns true if argument is a memory location
		def Location?( argument )
			index	= argument.to_s( ).to_i( 2 )
			return	Asm::Literals_Are_Magic::Type::BCPU::Word?( argument ) && Asm::Literals_Are_Magic::Type::Memory::Index?( index )
		end
		# strict type checking
		#
		# Returns true if argument is a memory (location) index
		def Index?( argument )
			return	Asm::Boilerplate::true_if_type( argument ,Integer ) && ( Asm::Literals_Are_Magic::Memory::inclusive_minimum_index <= argument ) && ( argument < Asm::Literals_Are_Magic::Memory::exclusive_maximum_index )
		end
	end
end