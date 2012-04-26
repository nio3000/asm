#!/usr/bin/ruby
=begin
... am concerned that ruby's integer representation is Choi's idea of cheating.
need to manipulate bits independent of integer representation.
=end

class	BCPU_integer_context
	def	valid?( integer_value )
		in_range?( integer_value )
	end
	def	validate!( integer_value )
		...
	end
end
class	BCPU_integer_literal
	def wild_set!( flag ,value ,context )
		# Regexps for flags & values of relevant literals
		any_binary_flag	= /0[bB]/
		any_binary_value	= /(?<value>[01]+)/
		any_decimal_flag	= /[dD]{,1}/
		any_decimal_value	= /(?<value>[\+\-]{,1}[0-9]+)/
		# organization
		binary	= { 'flag' => any_binary_flag ,'value' => any_binary_value ,'integer_base' => 2 }
		decimal	= { 'flag' => any_decimal_flag ,'value' => any_decimal_value ,'integer_base' => 10 }
		#
		if	!(decimal['flag'].match( flag ).nil?)
			value.to_i( type['integer_base'] )
		else if	!(binary['flag'].match( flag ).nil?)
			...
		else
			raise	"flag not recognized"
		end
		
=begin
match	= False
[binary ,decimal].each do |type|
	match	= !(type['flag'].match( flag ).nil?)
	if	match
		value.to_i( type['integer_base'] )
		yield
	end
end
=end
	end
end

class BCPU_literal
	def initialize( initial_value )
		if	initial_value.kind_of? String
			@value	= initial_value
		else if	initial_value.kind_of? Integer
			@value	= "%b" % initial_value
		else
			raise "initial value is of an unsupported type"
		end
	end
	def self.cast_to_nbit_unsigned( number_of_bits )
		raise "number_of_bits must be an integer" unless number_of_bits.kind_of? Integer
		
	end
end

aya	= BCPU_literal.new


class iota
	def initialize( flag, value )
		
		@flag	= flag
		
		raise "Ojou-sama, that is inappropriate."	unless value.kind_of? String
		@value	= value
		
	end
	attr_accessor :flag
	attr_accessor :value
end

the_binary_flag	= "b"
the_decimal_flag	= "d"
the_hexadecimal_flag	= "h"

a_literal	= iota.new( the_decimal_flag ,"65535" )
unpacked_literal	= a_literal.value.unpack( )

was going to work with type conversions via pack & unpack

=begin
from perspective of looking at BCPU assembly source
all literals have a flag and a value.
The value is the string of characters as it appears in the BCPU assembly source.
	only the characters that constitute a number in that base.
The flag is the language-specific identifier prefix from the BCPU assembly source that states what encoding the value should be interpreted as.
	for decimal encodings, the flag is either 'd' or nonexistant
		wait. . . d111 is a valid hexadecimal value presented without a flag. . . maybe that complicates matters?
	hexadecimal encodings are no longer supported.
	binary encodings have a flag of "0b" (or 'b' in legacy mode)
the regex for any literal should seek [flag ,value] information
application of the regex should also bear [context] information
	the maximum significant binary length is information in [context]
	whether or not the value is signed or unsigned or either is information in [context]
arbitrary BCPU literals are constructed from [flag ,value ,context]
	invalid flags are invalid BCPU literals
	invalid values for the given flag are invalid BCPU literals
	invalid values for the given context are invalid BCPU literals
invalid BCPU_literals have undefined state and signal their reason for invalidity
valid BCPU_literals have context-appropriate binary string representation and signal their validity
=end

def	verbose_construct_BCPU_literal( flag ,value ,context )
	unless	...	# test for flag validity
		reason = "flag not recongized, thus the literal is unintelligible"
	else unless	...	# test for value validity given a valid flag
		reason = "given flag=#{flag}, value not recongized, thus the literal is unintelligible"
	else unless	...	# test for context validity given a valid value & flag
		reason = "the literal is intelligible but is not appropriate to the context, thus the literal is invalid"
	else	# valid BCPU literal for the given context
		reason = "the literal is intelligible and appropriate to the context, thus the literal is valid"
		result = ...
	end
	# return context-appropriate & packed binary string along side reason
	return	reason ,result
end

=begin
BCPU_literal_case01
# BCPU_literal_case01 = BCPU_literal_case02
# BCPU_literal_case01 = asm
explicit usage case, memory location value from directive lhs

flag validity
	if decimal
		[d] at most once
		/[d]{,1}/
	if binary
		0b once
		/0b/

value validity given flag
	if decimal
		[+] at most once, then [0-9]+
		/[\+]{,1}[0-9]+/
	if binary
		[0-1]+
		/[01]+/

context validity wrt value range
	dvalue >= d0
	dvalue < d(2^16)

context validity wrt maximum binary legnth
	value casted to binary is less than or equal to 16 bits.

result will be used to index a memory location
=end

=begin
BCPU_literal_case02
# BCPU_literal_case01 = BCPU_literal_case02
explicit usage case, literal value from directive rhs

flag validity
	if decimal
		[d] at most once
		/[d]{,1}/
	if binary
		0b once
		/0b/

value validity given flag
	if decimal
		[+-] at most once, then [0-9]+
		/[\+\-]{,1}[0-9]+/
	if binary
		[0-1]+
		/[01]+/

context validity wrt value range
	dvalue > d(-2^15)
	dvalue < d(2^16)

context validity wrt maximum binary legnth
	value casted to binary is less than or equal to 16 bits.

result will be used to assign value to a memory location
=end

=begin
BCPU_literal_case03
SET	RD ,BCPU_literal_case03
SETH	RD ,BCPU_literal_case03
explicit usage case, 8 bit literal value from instruction

flag validity
	if decimal
		[d] at most once
		/[d]{,1}/
	if binary
		0b once
		/0b/

value validity given flag
	if decimal
		[+] at most once, then [0-9]+
		/[\+]{,1}[0-9]+/
	if binary
		[0-1]+
		/[01]+/

context validity wrt value range
	dvalue >= d(0)
	dvalue < d(2^8)

context validity wrt maximum binary legnth
	value casted to binary is less than or equal to 8 bits.

result will be used to creat new value
new value will be assigned to a memory location
=end

=begin
BCPU_literal_case04
ADDI	RD ,RA ,BCPU_literal_case04
SUBI	RD ,RA ,BCPU_literal_case04
INCIZ	RD ,BCPU_literal_case04 ,RB
DECIN	RD ,BCPU_literal_case04 ,RB
explicit usage case, 4 bit literal value from instruction

flag validity
	if decimal
		[d] at most once
		/[d]{,1}/
	if binary
		0b once
		/0b/

value validity given flag
	if decimal
		[+] at most once, then [0-9]+
		/[\+]{,1}[0-9]+/
	if binary
		[0-1]+
		/[01]+/

context validity wrt value range
	dvalue >= d(0)
	dvalue < d(2^4)

context validity wrt maximum binary legnth
	value casted to binary is less than or equal to 4 bits.

result will be used to create new value suitable to a memory location
new value will be passed as register contents to an instuction
=end

=begin
BCPU literal supremum candidates; most inclusive context independent validity

any_binary_flag	= /0[bB]/
any_binary_value	= /[01]+/

any_decimal_flag	= /[dD]{,1}/
any_decimal_value	= /[\+\-]{,1}[0-9]+/

any_BCPU_integer_literal	= /(#{any_binary_flag}#{any_binary_value})|(#{any_decimal_flag}#{any_decimal_value})/

flag_and_value_of_any_BCPU_integer_literal	= /((?<the_flag>#{any_binary_flag})(?<the_value>#{any_binary_value}))|((?<the_flag>#{any_decimal_flag})(?<the_value>#{any_decimal_value}))/
/#{flag_and_value_of_any_BCPU_integer_literal}/	~= text
construct_BCPU_literal( the_flag ,the_value ,the_context )

note, register index literals can also be treated in a flag-value manner unambiguously.

any_register_flag	= /[rR]/
any_register_value	= /[0-9]+/

flag_and_value_of_any_BCPU_literal	=
	/(	(?<the_flag>#{any_binary_flag})
		(?<the_value>#{any_binary_value})
	)|(	(?<the_flag>#{any_decimal_flag})
		(?<the_value>#{any_decimal_value})
	)|(	(?<the_flag>#{any_register_flag})
		(?<the_value>#{any_register_value})
	)/

note: this might fail if #{var} syntax is disallowed inside capture names, but that would be anti-reflection. . .
alternative: build regex from string, substitute into string as expected.

def	regex_to_capture_literals_flag_and_value	local_flag_capture_name ,local_value_capture_name
	any_binary_flag	= /0[bB]/
	any_binary_value	= /[01]+/
	any_decimal_flag	= /[dD]{,1}/
	any_decimal_value	= /[\+\-]{,1}[0-9]+/
	any_register_flag	= /[rR]/
	any_register_value	= /[0-9]+/
	/((?<#{local_flag_capture_name}>#{any_binary_flag})(?<#{local_value_capture_name}>#{any_binary_value}))|((?<#{local_flag_capture_name}>#{any_decimal_flag})(?<#{local_value_capture_name}>#{any_decimal_value}))|((?<#{local_flag_capture_name}>#{any_register_flag})(?<#{local_value_capture_name}>#{any_register_value}))/
end

text	= "whatever"
flag_and_value_of_any_literal	= regex_to_capture_literals_flag_and_value "mai_flag" "mai_value"
flag_and_value_of_any_literal	~= text
puts mai_flag
puts mai_value

=end

=begin
todo:
	compile & test sapphire.rb
	add usage case for BCPU literal context applied to results & intermediates in instructions.
=end



##################################################################################################################################

=begin
BCPU_literal_case01
# BCPU_literal_case01 = BCPU_literal_case02
# BCPU_literal_case01 = asm
explicit usage case, memory location value from directive lhs

flag capture
	/[d]{,1}/ #=> decimal
	/0b/ #=> binary
value capture
	decimal #=> /[\+]{,1}[0-9]+/
	binary #=> /[01]+/
context validity wrt value range	same!
	decimal #=> d0 <= value < d2^d16
	binary #=> b0000000000000000 <= value <= b1^d16
=end

=begin
BCPU_literal_case02
# BCPU_literal_case01 = BCPU_literal_case02
explicit usage case, literal value from directive rhs

flag capture
	/[d]{,1}/ #=> decimal
	/0b/ #=> binary
value capture
	decimal #=> /[\+\-]{,1}[0-9]+/
	binary #=> /[01]+/
context validity wrt value range	different!
	decimal #=> d-1*(d2^d15) <= value < d2^d16
	binary #=> b0000000000000000 <= value <= b1^d16
=end

=begin
BCPU_literal_case03
SET	RD ,BCPU_literal_case03
SETH	RD ,BCPU_literal_case03
explicit usage case, 8 bit literal value from instruction

flag capture
	/[d]{,1}/ #=> decimal
	/0b/ #=> binary
value capture
	decimal #=> /[\+]{,1}[0-9]+/
	binary #=> /[01]+/
context validity wrt value range	same!
	decimal #=> d0 <= value < d2^d8
	binary #=> b00000000 <= value <= b1^d8
=end

=begin
BCPU_literal_case04
ADDI	RD ,RA ,BCPU_literal_case04
SUBI	RD ,RA ,BCPU_literal_case04
INCIZ	RD ,BCPU_literal_case04 ,RB
DECIN	RD ,BCPU_literal_case04 ,RB
explicit usage case, 4 bit literal value from instruction

flag capture
	/[d]{,1}/ #=> decimal
	/0b/ #=> binary
value capture
	decimal #=> /[\+]{,1}[0-9]+/ #=> decimal_value_string
	binary #=> /[01]+/ #=> binary_value_string
context validity wrt value range	same!
	decimal #=> d0 <= value < d2^d4
	binary #=> b0000 <= value <= b1^d4
=end
