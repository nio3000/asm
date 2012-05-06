=begin
# /lib/Asm/Literals_are_Magic.rb
* complete definition of module Asm::Magic and all nested modules thereof
=end
module Asm
=begin
	# Asm::Magic
	    * hardcoded immutable values # TODO figure out how to make them immutable
	## design choice
	* refactor multiple-word names into nested modules
		* indulge in ludicrously explanatory variable names
		* I don't care if it takes you forever to type the full nested name
		* this design choice is for reading them
=end
	module Magic
=begin
		# Asm::Magic::Memory
=end
		module	Memory
=begin
			# Asm::Magic::Memory::Bits_per
=end
			module	Bits_per
				Word	    = 16	 # one word's worth of bits is the number of bits associated with a memory location or memory value
				Halfword	= 8
				Quarterword	= 4
			end
=begin
		# Asm::Magic::Memory::Index
		* minimums & maximums in inclusive & exclusive flavours
=end
			module	Index
				module	Inclusive
					Minimum	= 0
					Maximum	= 65535
				end
				module	Exclusive
					Minimum	= Asm::Magic::Memory::Index::Inclusive::Minimum - 1
					Maximum	= Asm::Magic::Memory::Index::Inclusive::Maximum + 1	# 2^16 = 65536
				end
			end
		end
=begin
		# Asm::Magic::Binary
=end
		module	Binary
=begin
			# Asm::Magic::Binary::Twos_complement
=end
			module	Twos_complement
				module	Exclusive
					Maximum	= 2 ** (Asm::Magic::Memory::Bits_per::Word - 1) # 2^15 = ???
					Minimum	= -(Asm::Magic::Binary::Twos_complement::Exclusive::Maximum + 1)
				end
				module	Inclusive
					Minimum	= Asm::Magic::Binary::Twos_complement::Exclusive::Minimum + 1
					Maximum	= Asm::Magic::Binary::Twos_complement::Exclusive::Maximum - 1
				end
				# twos complement range checking
				def	self.valid?( an_Integer )
					return	( an_Integer > Exclusive::Minimum ) && ( an_Integer < Exclusive::Maximum )
				end
				# twos complement range checking
				def	self.assert_valid( an_Integer )
					if !(an_Integer < Asm::Magic::Binary::Twos_complement::Exclusive::Maximum)
						raise 'The integer, \'' << an_Integer << '\',  is too positive for twos complement encoded in ' << Asm::Magic::Memory::Bits_per::Word << 'bits.'
					elsif !(Asm::Magic::Binary::Twos_complement::Exclusive::Minimum < an_Integer)
						raise 'The integer, \'' << an_Integer << '\',  is too negative for twos complement encoded in ' << Asm::Magic::Memory::Bits_per::Word << 'bits.'
					end
					return
				end
			end
=begin
			# Asm::Magic::Binary::Unsigned
			
=end
			module	Unsigned
				module	Exclusive
					Maximum	= 2 ** Asm::Magic::Memory::Bits_per::Word # 2^16 = 65536
				end
				module	Inclusive
					Minimum	= 0
					Maximum	= Asm::Magic::Binary::Unsigned::Exclusive::Maximum - 1
				end
				module	Exclusive
					Minimum	= Asm::Magic::Binary::Unsigned::Inclusive::Minimum - 1
				end
				# unsigned binary range checking
				def	self.valid?( an_Integer )
					return	( an_Integer > Exclusive::Minimum ) && ( an_Integer < Exclusive::Maximum )
				end
				# unsigned binary range checking
				def	self.assert_valid( an_Integer )
					if !(an_Integer < Asm::Magic::Binary::Unsigned::Exclusive::Maximum)
						raise 'The integer, \'' << an_Integer << '\', is too positive for unsigned binary encoded in ' << Asm::Magic::Memory::Bits_per::Word << 'bits.'
					elsif !(Asm::Magic::Binary::Unsigned::Exclusive::Minimum < an_Integer)
						raise 'The integer, \'' << an_Integer << '\',  is too negative for unsigned binary encoded in ' << Asm::Magic::Memory::Bits_per::Word << 'bits.'
					end
					return
				end
			end
			# DOCIT
			module	String
				# true if there is evidence that the given string is not a binary string.
				def	self.valid?( a_String )
					return	(a_String.size == a_String.count( '01' )) && (a_String.size > 0)
				end
				# raise if there is evidence that the given string is not a binary string.
				def	self.assert_valid( a_String )
					if	!Asm::Magic::Binary::String::valid?( a_String )
						raise 'the given string, \'' << a_String << '\', is not a binary String.'
					end
					return
				end
			end
			# DOCIT
			module	Bitset
				# true if there is evidence that the given Bitset instance is not a BCPU compatible Bitset.
				def	self.valid?( a_Bitset )
					return	a_Bitset.size <= Asm::Magic::Memory::Bits_per::Word
				end
				# raise if there is evidence that the given string is not a binary string.
				def	self.assert_valid( a_Bitset )
					if	!Asm::Magic::Binary::Bitset::valid?( a_Bitset )
						raise 'the given bitset, \'' << a_Bitset.to_s << '\', contains more than ' << Asm::Magic::Memory::Bits_per::Word << 'bits; assigning it may lose information in an unintended way.'
					end
					return
				end
			end
		end
=begin
		# Asm::Magic::Base10
=end
		module Base10
			# DOCIT
			module	String
				# true if there is evidence that the given string is not a base 10 string of digits.
				def	self.valid?( a_String )
					return	(a_String.size == a_String.count( '+-0123456789' )) && (a_String.size > 0)
				end
				# raise if there is evidence that the given string is not a base 10 string of digits.
				def	self.assert_valid( a_String )
					if	!Asm::Magic::Base10::String::valid?( a_String )
						raise 'the given string, \'' << a_String << '\', is not a base 10 string of digits.'
					end
					return
				end
			end
		end
=begin
		# Asm::Magic::Loader
=end
		module	Loader
			module	Load
				module	Index
					# True iff the given load index is in a valid state
					def self.valid?( an_Integer )
						raise 'an_Integer is not an integer' unless an_Integer.integer?
						return	(an_Integer >= Asm::Magic::Memory::Index::Inclusive::Minimum) && (an_Integer <= Asm::Magic::Memory::Index::Inclusive::Maximum)
					end
					# raise unless the given load index is in a valid state
					def self.assert_valid( an_Integer )
						raise 'an_Integer is not an integer' unless an_Integer.integer?
						if !(an_Integer >= Asm::Magic::Memory::Index::Inclusive::Minimum)
							raise 'the load index, \'' << an_Integer << '\', is less than \'' << Asm::Magic::Memory::Index::Inclusive::Minimum << '\''
						elsif !(an_Integer <= Asm::Magic::Memory::Index::Inclusive::Maximum)
							raise 'the load index, \'' << an_Integer << '\', is greater than \'' << Asm::Magic::Memory::Index::Inclusive::Maximum << '\''
						end
						return
					end
					# a safe to use invalid load index that should be assigned anytime the Loader's load index needs to be in an invalid (unusable) state.
					Invalid	= Asm::Magic::Memory::Index::Exclusive::Minimum
				end
			end
		end
=begin
		# Asm::Magic::Register
=end
		module	Register
=begin
			# Asm::Magic::Register::Index
			* memory indicies of unique special function registers
			* minimums & maximums in inclusive & exclusive flavours
=end
			module Index
				module	Inclusive
					Minimum	= 0
					Maximum	= 15
				end
				module	Exclusive
					Minimum	= Asm::Magic::Register::Index::Inclusive::Minimum - 1
					# 2^4 = 16
					Maximum	= Asm::Magic::Register::Index::Inclusive::Maximum + 1
				end
				#15
				Program_counter	= Asm::Magic::Register::Index::Inclusive::Maximum
			end
=begin
		# Asm::Magic::Register::Indicies
		* memory indicies of categories of special function registers
=end
			module Indicies
				Input_registers	 = [ 6 ]
				Output_registers = [ 13 ,14 ]
			end
=begin
			# Asm::Magic::Register::Location
			* memory locations of unique special function registers
=end
			module Location
			end
=begin
			# Asm::Magic::Register::Locations
			* memory locations of ategories of special function registers
=end
			module Locations
			end
		end
=begin
		# Asm::Magic::Regexp
		* DOCIT
=end
		module Regexp
			# maintainable boilerplate for contructing a Regexp object; adds modifiers silently
			def self.create( a_Regexp_String )
				# Paranoid type checking
				Asm::Boilerplate::raise_unless_type( a_Regexp_String ,::String )
				# Regexp instantiation with modifiers
				# * ::Regexp::IGNORECASE -> case insensitive Regexp instance
				::Regexp.new( a_Regexp_String ,::Regexp::IGNORECASE )
			end
			module	String
#=begin
				# wraps a given String, a_Regexp_String, in a named capture block with name a_String_for_a_name
				#
				# Returns a new Regexp_String
				def	self.named_capture( a_Regexp_String ,a_String_for_a_name )
					return	'(?<' << a_String_for_a_name << '>' << a_Regexp_String << ')'
				end
				# DOCIT
				#
				# Returns a new Regexp_String
				def	self.consume_capture( a_Regexp_String )
					return	'^' << a_Regexp_String << '$'
				end
				module	::Asm::Magic::Regexp::String::Names
					module	Register
						A	= 'registry a'
						B	= 'registry b'
						D	= 'registry dest'
					end
					module	Numeric
						Literal	= 'literal'
					end
					module	::Asm::Magic::Regexp::String::Names::Directive
						LHS	= 'lhs'
						RHS	= 'rhs'
					end
					Keyword	= 'keyword'
					Flag	= 'flag'
					Value	= 'value'
				end
				module	::Asm::Magic::Regexp::String::Optional
					Whitespace	= '\s*'	# whitespace character zero or more times
				end
				Beginning_of_line	= '^' << ::Asm::Magic::Regexp::String::Optional::Whitespace	# forces regex match to start from the beginning of the input text; also consumes whitespace
=begin
				# Asm::Magic::Regexp::String::Asm
				* Rexexp Strings pertaining to low level parts of BCPU assembly language features
=end
				module	::Asm::Magic::Regexp::String::Asm
					Comment	= '' << ::Asm::Magic::Regexp::String::Optional::Whitespace << '//.*$'	# optional whitespace followed by a comment followed by optional anything; also forced consume until end of line or fail to match
					module	::Asm::Magic::Regexp::String::Asm::Register
						Flag	= '[rR]'
						Value	= '[0-9]+'
						Literal	= Flag + Value
						module	Capture
							RA	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Register::Literal ,::Asm::Magic::Regexp::String::Names::Register::A )
							RB	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Register::Literal ,::Asm::Magic::Regexp::String::Names::Register::B )
							RD	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Register::Literal ,::Asm::Magic::Regexp::String::Names::Register::D )
							Flag_Value	= '' << ::Asm::Magic::Regexp::String.named_capture( Flag ,::Asm::Magic::Regexp::String::Names::Flag ) << ::Asm::Magic::Regexp::String.named_capture( Value ,::Asm::Magic::Regexp::String::Names::Value )
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Binary
						Flag	= '0[bB]'
						Value	= '[01]+'
						Literal	= Flag + Value
						module	Capture
							Flag_Value	= '' << ::Asm::Magic::Regexp::String.named_capture( Flag ,::Asm::Magic::Regexp::String::Names::Flag ) << ::Asm::Magic::Regexp::String.named_capture( Value ,::Asm::Magic::Regexp::String::Names::Value )
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Base10
						Flag	= '[dD]{,1}'
						Value	= '[+\-]{,1}[0-9]+'
						Literal	= Flag + Value
						module	Capture
							Flag_Value	= '' << ::Asm::Magic::Regexp::String.named_capture( Flag ,::Asm::Magic::Regexp::String::Names::Flag ) << ::Asm::Magic::Regexp::String.named_capture( Value ,::Asm::Magic::Regexp::String::Names::Value )
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Numeric
						Literal	= '(' << ::Asm::Magic::Regexp::String::Asm::Base10::Literal << ')|(' << ::Asm::Magic::Regexp::String::Asm::Binary::Literal << ')'
						module	::Asm::Magic::Regexp::String::Asm::Numeric::Capture
							Literal	= '(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Base10::Literal ,::Asm::Magic::Regexp::String::Names::Numeric::Literal ) << ')|(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Binary::Literal ,::Asm::Magic::Regexp::String::Names::Numeric::Literal ) << ')'
							Flag_Value	= ::Asm::Magic::Regexp::String::Asm::Binary::Capture::Flag_Value + '|' + ::Asm::Magic::Regexp::String::Asm::Base10::Capture::Flag_Value
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Keyword
						Asm	= 'ASM'
						RD_RA	= '(MOVE)|(NOT)'
						RD_RA_RB	= '(AND)|(OR)|(ADD)|(SUB)|(MOVEZ)|(MOVEX)|(MOVEP)|(MOVEN)'
						RD_RA_data	= '(ADDI)|(SUBI)'
						RD_data_RB	= '(INCIZ)|(DECIN)'
						RD_data	= '(SET)|(SETH)'
						module	Capture
							RD_RA	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Keyword::RD_RA ,::Asm::Magic::Regexp::String::Names::Keyword )
							RD_RA_RB	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Keyword::RD_RA_RB ,::Asm::Magic::Regexp::String::Names::Keyword )
							RD_RA_data	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Keyword::RD_RA_data ,::Asm::Magic::Regexp::String::Names::Keyword )
							RD_data_RB	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Keyword::RD_data_RB ,::Asm::Magic::Regexp::String::Names::Keyword )
							RD_data	= ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Keyword::RD_data ,::Asm::Magic::Regexp::String::Names::Keyword )
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Instruction
						Prefix	= '' << Beginning_of_line
						Delimiter	= '' << ::Asm::Magic::Regexp::String::Optional::Whitespace << ',' << ::Asm::Magic::Regexp::String::Optional::Whitespace	# a comma, optionally surrounded by whitespace; the delimiter in instructions
						Suffix	= '' << Comment
						module	::Asm::Magic::Regexp::String::Asm::Instruction::Format
							RD_RA	= '' << Prefix << ::Asm::Magic::Regexp::String::Asm::Keyword::Capture::RD_RA << ::Asm::Magic::Regexp::String::Optional::Whitespace << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RD << Delimiter << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RA << Suffix
							RD_RA_RB	= '' << Prefix << ::Asm::Magic::Regexp::String::Asm::Keyword::Capture::RD_RA_RB << ::Asm::Magic::Regexp::String::Optional::Whitespace << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RD << Delimiter << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RA << Delimiter << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RB << Suffix
							RD_RA_data	= '' << Prefix << ::Asm::Magic::Regexp::String::Asm::Keyword::Capture::RD_RA_data << ::Asm::Magic::Regexp::String::Optional::Whitespace << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RD << Delimiter << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RA << Delimiter << ::Asm::Magic::Regexp::String::Asm::Numeric::Capture::Literal << Suffix
							RD_data_RB	= '' << Prefix << ::Asm::Magic::Regexp::String::Asm::Keyword::Capture::RD_data_RB << ::Asm::Magic::Regexp::String::Optional::Whitespace << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RD << Delimiter << ::Asm::Magic::Regexp::String::Asm::Numeric::Capture::Literal << Delimiter << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RB << Suffix
							RD_data	= '' << Prefix << ::Asm::Magic::Regexp::String::Asm::Keyword::Capture::RD_data << ::Asm::Magic::Regexp::String::Optional::Whitespace << ::Asm::Magic::Regexp::String::Asm::Register::Capture::RD << Delimiter << ::Asm::Magic::Regexp::String::Asm::Numeric::Capture::Literal << Suffix
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Directive
						Prefix	= '' << Beginning_of_line << '#' << ::Asm::Magic::Regexp::String::Optional::Whitespace	# directive symbol followed by optional whitespace
						Delimiter	= '' << ::Asm::Magic::Regexp::String::Optional::Whitespace << '=' << ::Asm::Magic::Regexp::String::Optional::Whitespace
						Suffix	= '' << Comment
						LHS	= '' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Numeric::Literal ,::Asm::Magic::Regexp::String::Names::Directive::LHS )
						#LHS	= '(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Base10::Literal ,::Asm::Magic::Regexp::String::Names::Directive::LHS ) << ')|(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Binary::Literal ,::Asm::Magic::Regexp::String::Names::Directive::LHS ) << ')'
						#RHS	= '(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Base10::Literal ,::Asm::Magic::Regexp::String::Names::Directive::RHS ) << ')|(' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Binary::Literal ,::Asm::Magic::Regexp::String::Names::Directive::RHS ) << ')'
						RHS	= '' << ::Asm::Magic::Regexp::String.named_capture( ::Asm::Magic::Regexp::String::Asm::Numeric::Literal ,::Asm::Magic::Regexp::String::Names::Directive::RHS )
						module	::Asm::Magic::Regexp::String::Asm::Directive::Format
							Asm	= '' << ::Asm::Magic::Regexp::String::Asm::Directive::Prefix << ::Asm::Magic::Regexp::String::Asm::Directive::LHS << ::Asm::Magic::Regexp::String::Asm::Directive::Delimiter << ::Asm::Magic::Regexp::String::Asm::Keyword::Asm << ::Asm::Magic::Regexp::String::Asm::Directive::Suffix	# # number = asm
							Assignment	= '' << ::Asm::Magic::Regexp::String::Asm::Directive::Prefix << ::Asm::Magic::Regexp::String::Asm::Directive::LHS << ::Asm::Magic::Regexp::String::Asm::Directive::Delimiter << ::Asm::Magic::Regexp::String::Asm::Directive::RHS << ::Asm::Magic::Regexp::String::Asm::Directive::Suffix	# # number = number
						end
					end
					module	::Asm::Magic::Regexp::String::Asm::Ignore
						Comment	= '' << Beginning_of_line << ::Asm::Magic::Regexp::String::Asm::Comment
						Blank	= '' << Beginning_of_line << '$'
					end
				end
#=end
			end
		end
=begin
		# Asm::Magic::GUI
		* constants involved in the GUI
=end
		module GUI
			module Names
				Xrc_file	= './../lib/asm/gui/gui.xrc'
				Top_level	= 'Main_frame'
				module Loader
					Frame	= 'Loader_frame'
					Console	= 'Loader_console'
					Filepath	= 'Loader_filepath'
				end
				module VM
					Frame	= 'VM_frame'
					Memory	= 'VM_memory'
					Registers	= 'VM_registers'
				end
			end
		end
=begin
		# Asm::Magic::ISA
		* magic literals that appear in Choi's definition of the Instruction Set Architecture (ISA)
=end
		module ISA
			class Instruction
				def initialize( )
					@opcode	= -1
					@text	= 'Kya~' # exclaimed Pyrrha
					@format_text	= []
					@format_regex	= []
				end

				def opcode_as_binary_String
					# TODO implement
				end
				def keyword_as_String
					@text
				end
				def format_as_String
					@format_text
				end
				def format_as_String_regex
					result	= ''
					@format_regex.each do |literal_regex|
					end
				end
			end
=begin
			Integer OpCodes corresponding to
			* magic literals that appear in Choi's definition of the Instruction Set Architecture (ISA)
=end
			module Integer
				# Integer OpCodes
				MOVE  = 0
				NOT   = 1
				AND   = 2
				OR    = 3
				ADD   = 4
				SUB   = 5
				ADDI  = 6
				SUBI  = 7
				SET   = 8
				SETH  = 9
				INCIZ = 10
				DECIN = 11
				MOVEZ = 12
				MOVEX = 13
				MOVEP = 14
				MOVEN = 15
	
				# instructions and their 4 bit binary codes
				instructions = {'move'  => "%04d" % MOVE.to_s(2),
								'not'   => "%04d" % NOT.to_s(2),
								'and'   => "%04d" % AND.to_s(2),
								'or'    => "%04d" % OR.to_s(2),
								'add'   => "%04d" % ADD.to_s(2),
								'sub'   => "%04d" % SUB.to_s(2),
								'addi'  => "%04d" % ADDI.to_s(2),
								'subi'  => "%04d" % SUBI.to_s(2),
								'set'   => "%04d" % SET.to_s(2),
								'seth'  => "%04d" % SETH.to_s(2),
								'inciz' => "%04d" % INCIZ.to_s(2),
								'decin' => "%04d" % DECIN.to_s(2),
								'movez' => "%04d" % MOVEZ.to_s(2),
								'movex' => "%04d" % MOVEX.to_s(2),
								'movep' => "%04d" % MOVEP.to_s(2),
								'moven' => "%04d" % MOVEN.to_s(2)}
			end
		end
	end
end

#require	'Asm/require_all.rb'
#$LOAD_PATH << '.'
# encoding: UTF-8
