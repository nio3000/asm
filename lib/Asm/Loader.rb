=begin
# /lib/Asm/Loader.rb
* complete definition of class Asm::Loader
* unit tests on an instance of Asm::Loader
=end

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin	# Asm::Loader
	* initializes an instance of Asm::Virtual_Machine
	* maintains internal state related to loading machine code into an instance of Asm::Virtual_Machine
=end
	class	Loader
	public
=begin	structors & accessors
=end
		#The following are the name captures/regular expressions for capturing machines instructions
		#Literals
		registry = '(r|R)[0-9]+'
		decimal = '[d]{,1}[\+\-]{,1}[0-9]+'
		binary = '(0)(b|B)[\+\-]{,1}[0-1]+' #Accepts other digits but doesn't capture
		decimalUnsigned = '[0-9]+'
		
		captureBOL = '(?<begin of line>^)' #^
		captureEOL = '(?<end of line>$)' #$
		
		captureKeyword0 = '(?<keyword>(MOVE)|(NOT))' #0 Corresponds
		captureKeyword1 = '(?<keyword>((AND)|(OR)|(ADD)|(SUB)|(MOVEZ)|(MOVEX)|(MOVEP)|(MOVEN)))'
		captureKeyword2 = '(?<keyword>(ADDI)|(SUBI))'
		captureKeyword3 = '(?<keyword>(SET)|(SETH))'
		captureKeyword4 = '(?<keyword>(INCIZ)|(DECIN))'
		
		captureWhitespace = '(?<whitespace>[\s\t]*)'
		captureWhitespaceReg = '(?<whitespace>[\s\t]+)'
		captureRegALiteral = '(?<registry a>' + registry +')'
		captureRegBLiteral = '(?<registry b>' + registry +')'
		captureRegDESTLiteral = '(?<registry dest>' + registry +')'
		captureLiteral = '(?<literal>(' + decimal + ')|(' + binary + '))'
		captureDelimiter = '(?<delimiter>[,])'
		captureComment = '(?<Comment>(//.*){,1})' 
		
		captureASM = '(?<ASM>(ASM))'
		poundLiteral = '(?<memory literal>(#)(' + decimalUnsigned + '))' 
		equalDelimiter = '(?<delimiter>[=])'
		
		dev0 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
		 + captureLiteral + captureWhitespace + captureComment
		 
		dev1 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
		 + captureASM + captureWhitespace + captureComment
		
		format0 = captureBOL + captureWhitespace + captureKeyword0 + captureWhitespaceReg + captureRegDESTLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegALiteral + captureWhitespace \
		 + captureComment + captureEOL
		 
		format1 = captureBOL + captureWhitespace + captureKeyword1 + captureWhitespaceReg + captureRegDESTLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegALiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureRegBLiteral + captureWhitespace + captureComment + captureEOL
		 
		format2 = captureBOL + captureWhitespace + captureKeyword2 + captureWhitespaceReg + captureRegDESTLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegALiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment + captureEOL
		 
		format3 = captureBOL + captureWhitespace + captureKeyword3 + captureWhitespaceReg + captureRegDESTLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment + captureEOL
		 
		format4 = captureBOL + captureWhitespace + captureKeyword4 + captureWhitespaceReg + captureRegDESTLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureRegALiteral + captureWhitespace + captureComment + captureEOL
		 
		formatComment = captureBOL + captureWhitespace + captureComment
		formatWhite = captureBOL + captureWhitespace
		
		#New Expressions
		format0RegEx = Regexp.new(format0)
		format1RegEx = Regexp.new(format1)
		format2RegEx = Regexp.new(format2)
		format3RegEx = Regexp.new(format3)
		format4RegEx = Regexp.new(format4)
		
		dev0RegEx = Regexp.new(dev0)
		dev1RegEx = Regexp.new(dev1)
		
		commentRegEx = Regexp.new(formatComment)
		whiteRegEx = Regexp.new(formatWhite)
		
		# get & set the_Virtual_Machine; is an instance of Asm::Virtual_Machine
		attr_accessor :the_Virtual_Machine
		# get & set the memory index at which the Loader will load machine code into the Virtual_Machine's memory; is an Integer
		attr_accessor :load_index
		# initializing constructor
		#
		# the_Virtual_Machine	- reference to a Virtual_Machine instance
		def initialize( the_Virtual_Machine )
			# paranoid type checking of arguments.
			Asm::Boilerplate.raise_unless_type( the_Virtual_Machine ,Asm::Virtual_Machine )
			# initialize all persistant member variables.
			@the_Virtual_Machine	= the_Virtual_Machine
			self.invalidateLoadIndex
		end
		# Returns the load index interpretted as an instance of Asm::BCPU::Memory::Location
		def getLocationFromLoadIndex
			# if the load index is in an invalid state when this method is called, raise an error
			if	Asm::Magic::Loader::Load::Index.valid?( self.load_index )
				raise Asm::Boilerplate::Exception::Syntax.new( 'invalid load index state; directives following \'# loc = asm\' invalidate the load index state.' )
			end
			# return the Asm::BCPU::Memory::Location corresponding to the load index
			return	Asm::BCPU::Memory::Location.new( self.load_index )
		end
		# Increment the load index OR 
		# raise error if load index is a invalid value
		# Returns nothing
		def incrementLoadIndex
			# if the load index is in an invalid state when this method is called, raise an error
			if	Asm::Magic::Loader::Load::Index.valid?( self.load_index )
				raise Asm::Boilerplate::Exception::Syntax.new( 'invalid load index state; directives following \'# loc = asm\' invalidate the load index state.' )
			end
			self.load_index	+= 1
			return
		end
		# Sets load index to a invalid state
		#
		# Returns nothing
		def invalidateLoadIndex
			self.load_index	= Asm::Magic::Loader::Load::Index::Invalid
			return
		end
		# Sets the load index
		#
		# Returns nothing
		def setLoadIndex( an_integer )
			if	Asm::Magic::Loader::Load::Index.valid?( an_integer )
				raise Asm::Boilerplate::Exception::Syntax.new( 'invalid attempt to set load index state; \'' << an_integer << '\' is not a valid index for a memory location.' )
			else
				self.load_index	= an_integer
			end
			return
		end
		# DOCIT
		def word_from_register_literal( a_register_literal )
			# TODO refactor these & merge with other regex constants
			register_flag	= 'd{,1}'
			base10_number	= '[+\-]{,1}[0-9]+'
			register_literal	= '^' << '(?<flag>' << register_flag << ')' << '(?<value>' << base10_number << ')' << '$'
			#
			capture_register_literal	= Regexp.new( register_literal )
			match_info	= capture_register_literal.match( a_register_literal )
			raise 'register literal expected from \'' << a_register_literal << '\'' if !match_info
			Asm::BCPU::Word.new().assign_decimal_String( match_info[value] )
		end
		# DOCIT
		def word_from_numeric_literal( a_numeric_literal )
			# TODO refactor these & merge with other regex constants
			binary_flag	= '0[bB]'
			binary_number	= '[01]+'
			base10_flag	= 'd{,1}'
			base10_number	= '[+\-]{,1}[0-9]+'
			binary_literal	= '^' << '(?<flag>' << binary_flag << ')' << '(?<value>' << binary_number << ')$'
			decimal_literal	= '^' << '(?<flag>' << decimal_flag << ')' << '(?<value>' << decimal_number << ')$'
			#
			binary_match_info	= Regexp.new( binary_literal ).match( a_numeric_literal )
			decimal_match_info	= Regexp.new( decimal_literal ).match( a_numeric_literal )
			#
			if !binary_match_info && decimal_match_info
				return	Asm::BCPU::Word.new().assign_decimal_String( decimal_match_info[value] )
			elsif binary_match_info && !decimal_match_info
				return	Asm::BCPU::Word.new().assign_binary_String( binary_match_info[value] )
			elsif binary_match_info && decimal_match_info
				raise 'decimal or binary literal expected from \'' << a_numeric_literal << '\', but it\'s too ambiguous to tell which'
			else
				raise 'decimal or binary literal expected from \'' << a_numeric_literal << '\''
			end
		end
		# DOCIT
		def location_from_numeric_literal( a_numeric_literal )
			# TODO refactor these & merge with other regex constants
			binary_flag	= '0[bB]'
			binary_number	= '[01]+'
			base10_flag	= 'd{,1}'
			base10_number	= '[+\-]{,1}[0-9]+'
			binary_literal	= '^' << '(?<flag>' << binary_flag << ')' << '(?<value>' << binary_number << ')$'
			decimal_literal	= '^' << '(?<flag>' << decimal_flag << ')' << '(?<value>' << decimal_number << ')$'
			#
			binary_match_info	= Regexp.new( binary_literal ).match( a_numeric_literal )
			decimal_match_info	= Regexp.new( decimal_literal ).match( a_numeric_literal )
			#
			if !binary_match_info && decimal_match_info
				return	Asm::BCPU::Memory::Location.new().assign_decimal_String( decimal_match_info[value] )
			elsif binary_match_info && !decimal_match_info
				return	Asm::BCPU::Memory::Location.new().assign_binary_String( binary_match_info[value] )
			elsif binary_match_info && decimal_match_info
				raise 'decimal or binary literal expected from \'' << a_numeric_literal << '\', but it\'s too ambiguous to tell which'
			else
				raise 'decimal or binary literal expected from \'' << a_numeric_literal << '\''
			end
		end
		# maps bits from part of one bitset to part of another; can do range checking on literals for the BCPU
		#
		# from_Range - the range of integer indicies in the source Bitset
		# from_Word - the source Bitset; does not get modified by this method
		# to_Range - the range of integer indicies in the destination Bitset
		# to_Word - the destination Bitset; does get modified by this method
		#
		# Raises if from_Bitset is nonzero outside of from_Range and if BCPU_range_checking is true 
		# Raises if the range's don't match up in cardinality
		# Returns nothing
		def map_bits_to_bits( from_Range ,from_Word ,to_Range ,to_Word ,bCPU_range_checking = true )
			# paranoid type checking
			Asm::Boilerplate::raise_unless_type( from_Range ,::Range )
			Asm::Boilerplate::raise_unless_type( to_Range ,::Range )
			Asm::Boilerplate::raise_unless_type( from_Word ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( to_Word ,::Asm::BCPU::Word )
			# paranoid range checking
			raise ('shenanigans; \'' << (from_Word.the_bits.size - 1) << '\' is not in \''<< from_Range.to_s << '\'') unless from_Range.include?( from_Word.the_bits.size - 1 )
			raise ('shenanigans; \'' << (to_Word.the_bits.size - 1) << '\' is not in \''<< to_Range.to_s << '\'') unless to_Range.include?( to_Word.the_bits.size - 1 )
			raise 'invalid mapping' unless	(from_Range.size == to_Range.size)
			# BCPU range checking
			if bCPU_range_checking
				(0..(Asm::Magic::Memory::Bits_per::Word - 1)).each do |from_index|
					if !(from_Range.include?( from_index )) && (from_Word.the_bits[from_index] == false )
						raise Asm::Boilerplate::Exception::Syntax.new( 'literal translates to binary value outside of supported range.' )
					end
				end
			end
			# do the mapping
			adjustment	= to_Range.begin - from_Range.begin
			from_Range.each do |from_index|
				to_index	= from_index + adjustment
				raise 'shenanigans' unless to_Range.include?( to_index )
				to_Word.the_bits[to_index]	= from_Word.the_bits[from_index]
			end
			return
		end
	public
=begin	interface related to telling the Loader to load into the virtual machine
=end
		# invoke Loader instance with a given file of BCPU assembly
		#
		# Returns an array of the first exception encountered for each line of text in the given file
		def load( path )
			messages	= []
			line_count	= 0
			if	File.file?( path )
				code	= File.open( path ,'r' )
				# parse individually each line in the file
				code.each_line do |line|
					line_count += 1
					begin
						self.handle( line )
					rescue Asm::Boilerplate::Exception::Syntax => a_syntax_error
						messages.push 'syntax error on line' << line_count << ': \"' << a_syntax_error.message << '\"'
					else
						an_error # TODO verify if this is appropriate or if this needs to be rescue Exception => ...
						messages.push 'unexpected error on line' << line_count << ': \"' << an_error.message << '\"'
					end
				end
			else
				messages.push '\'' << path << '\' is not a file.'
			end
			messages
		end
	private
=begin	dispatched messages based on the given line of text.
		* messages dispatching based on the given line of text.
		* dispatched messages based on the given line of text.
			* handle instructions
			* handle directives
=end
		# dispatch necessary messages based on the given line of text
		#
		# Returns nothing
		def handle( line_of_text )
			# check if 'keyword RD RA' instruction format consumes line
			# dispatch with information from named captures
			if capture = format0RegEx.match(line_of_text)
				instruction_format__keyword_RD_RA( capture['keyword'], capture['registry dest'], capture['registry a'] )
				
			# check if 'keyword RD RA RB' instruction format consumes line
			# dispatch with information from named captures
			elsif capture = format1RegEx.match(line_of_text)
				instruction_format__keyword_RD_RA_RB( capture['keyword'], capture['registry dest'], capture['registry a'], capture['registry b'] )
			
			# check if 'keyword RD RA literal' instruction format consumes line
			# dispatch with information from named captures
			elsif capture = format2RegEx.match(line_of_text)
				instruction_format__keyword_RD_RA_literal( capture['keyword'], capture['registry dest'], capture['registry a'], capture['literal'])
			
			# check if 'keyword RD literal' instruction format consumes line
			# dispatch with information from named captures
			elsif capture = format3RegEx.match(line_of_text)
				instruction_format__keyword_RD_literal( capture['keyword'], capture['registry dest'], capture['literal'])
			
			# check if 'keyword RD literal RA' instruction format consumes line
			# dispatch with information from named captures
			elsif capture = format4RegEx.match(line_of_text)
				instruction_format__keyword_RD_literal_RA( capture['keyword'], capture['registry dest'], capture['literal'], capture['registry a'])
			
			# check if '# memory_location_literal = memory_value_literal' directive consumes line
			# dispatch with information from named captures
			elsif capture = dev0RegEx.match(line_of_text)
				directive__memory_value(capture['memory literal'], capture['literal'])
			
			# check if '# memory_location_literal = asm' directive consumes line
			# dispatch with information from named captures
			elsif capture = dev1RegEx.match(line_of_text)
				directive__asm( capture['memory literal'] )
			
			# check if '//' format consumes line
			# ignore by doing nothing
			elsif capture = commentRegEx.match(line_of_text)

			elsif capture = whiteRegEx.match(line_of_text)

			
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'this is not BCPU assembly; Loader refuses to do anything with this.' )
			end
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg reg_a reg_b
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_RB( keyword ,dest_reg ,reg_a ,reg_b )
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			wordRB = self.word_from_register_literal(reg_b)
			value = Asm::BPCU::Memory::Value.new
			self.map_bits_to_bits( 0..3, wordRD, 8..11, value)
			self.map_bits_to_bits( 0..3, wordRA, 4..7, value)
			self.map_bits_to_bits( 0..3, wordRB, 0..3, value)
			
			if keyword == 'AND'
				value.the_bits[13] = True
			elsif keyword == 'OR'
				value.the_bits[12] = True
				value.the_bits[13] = True
			elsif keyword == 'ADD'
				value.the_bits[14] = True
			elsif keyword == 'SUB'
				value.the_bits[14] = True
				value.the_bits[12] = True
			elsif keyword == 'MOVEZ'
				value.the_bits[15] = True
				value.the_bits[14] = True
			elsif keyword == 'MOVEX'
				value.the_bits[15] = True
				value.the_bits[14] = True
				value.the_bits[12] = True
			elsif keyword == 'MOVEP'
				value.the_bits[15] = True
				value.the_bits[14] = True
				value.the_bits[13] = True
			elsif keyword == 'MOVEN'
				value.the_bits[15] = True
				value.the_bits[14] = True
				value.the_bits[13] = True
				value.the_bits[12] = True
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA( keyword ,dest_reg ,reg_a )
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			value = Asm::BPCU::Memory::Value.new
			self.map_bits_to_bits( 0..3, wordRD, 8..11, value)
			self.map_bits_to_bits( 0..3, wordRA, 4..7, value)
			
			if keyword == 'MOVE'
				#Nothing to do, Opcode: 0000
			elsif keyword == 'NOT'
				value.the_bits[12] = True
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a, literal
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_literal( keyword ,dest_reg ,reg_a ,literal )
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BPCU::Memory::Value.new
			self.map_bits_to_bits( 0..3, wordRD, 8..11, value)
			self.map_bits_to_bits( 0..3, wordRA, 4..7, value)
			self.map_bits_to_bits( 0..3, wordLit, 4..7, value)
			
			if keyword == 'ADDI'
				value.the_bits[13] = True
				value.the_bits[14] = True
			elsif keyword == 'SUBI'
				value.the_bits[13] = True
				value.the_bits[14] = True
				value.the_bits[12] = True
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_literal_RA( keyword ,dest_reg ,literal ,reg_a )
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BPCU::Memory::Value.new
			self.map_bits_to_bits( 0..3, wordRD, 8..11, value)
			self.map_bits_to_bits( 0..3, wordRA, 4..7, value)
			self.map_bits_to_bits( 0..3, wordLit, 4..7, value)
			
			if keyword == 'INCIZ'
				value.the_bits[13] = True
				value.the_bits[14] = True
			elsif keyword == 'DECIN'
				value.the_bits[13] = True
				value.the_bits[14] = True
				value.the_bits[12] = True
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal
		# DOCIT
		# # Returns nothing
		def instruction_format__keyword_RD_literal( keyword ,dest_reg ,literal )
			wordRD = self.word_from_register_literal(dest_reg)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BPCU::Memory::Value.new
			self.map_bits_to_bits( 0..3, wordRD, 8..11, value)
			self.map_bits_to_bits( 0..3, wordLit, 4..7, value)
			
			if keyword == 'SET'
				value.the_bits[13] = True
				value.the_bits[14] = True
			elsif keyword == 'SETH'
				value.the_bits[13] = True
				value.the_bits[14] = True
				value.the_bits[12] = True
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = memory_value_literal
		# DOCIT
		#
		# Returns nothing
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			location = self.location_from_numeric_literal(memory_location_literal)
			wordLit = self.word_from_numeric_literal(memory_value_literal)
			value = Asm::BPCU::Memory::Value.new(wordLit.the_bits)
			
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = asm
		# DOCIT
		#
		# Returns nothing
		def directive__asm( memory_location_literal )
			location = self.location_from_numeric_literal(memory_location_literal)
			self.setLoadIndex(location.to_i)
			return
		end
=begin
		# Unit tests on this class
		* any claim made in documentation ought to have a unit tests
			* TODO implement the unit tests
		* interpretation of each instruction ought to have a unit test
		* interpretation of strange language features ought to have stress tests
=end
		#class Test < Test::Unit::TestCase
		#end
	end
end

#require	'Asm/require_all.rb'
#$LOAD_PATH << '.'
# encoding: UTF-8
