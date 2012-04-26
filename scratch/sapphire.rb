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
