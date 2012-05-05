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
		captureRegLiteral = '(?<registry literal>' + registry +')'
		captureLiteral = '(?<literal>(' + decimal + ')|(' + binary + '))'
		captureDelimiter = '(?<delimiter>[,])'
		captureComment = '(?<Comment>(//.*){,1})' 
		
		captureASM = '(?<ASM>(ASM))'
		poundLiteral = '(?<literal>(#)(' + decimalUnsigned + '))' 
		equalDelimiter = '(?<delimiter>[=])'
		
		dev0 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
		 + captureLiteral + captureWhitespace + captureComment
		 
		dev1 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
		 + captureASM + captureWhitespace + captureComment
		
		format0 = captureBOL + captureWhitespace + captureKeyword0 + captureWhitespaceReg + captureRegLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
		 + captureComment + captureEOL
		 
		format1 = captureBOL + captureWhitespace + captureKeyword1 + captureWhitespaceReg + captureRegLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace + captureComment + captureEOL
		 
		format2 = captureBOL + captureWhitespace + captureKeyword2 + captureWhitespaceReg + captureRegLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment + captureEOL
		 
		format3 = captureBOL + captureWhitespace + captureKeyword3 + captureWhitespaceReg + captureRegLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment + captureEOL
		 
		format4 = captureBOL + captureWhitespace + captureKeyword4 + captureWhitespaceReg + captureRegLiteral \
		 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace \
		 + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace + captureComment + captureEOL
		 
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
			raise_unless_type( the_Virtual_Machine ,Asm::Virtual_Machine )
			# initialize all persistant member variables.
			@the_Virtual_Machine	= the_Virtual_Machine
			@load_index	= Asm::Literals_Are_Magic::Loader::example_invalid_load_index
		end
		
		#
		#
		# Returns the load index interpter as Asm::BCPU::Memory::Location
		def getLocationFromLoadIndex()
			
		end
		
		# Increment the load index OR
		# raise error if load index is a invalid value
		# Returns nothing
		def incrementLoadIndex()
			
		end
		
		# Sets load index to a invalid state
		#
		# Returns nothing
		def invalidateLoadIndex()
		end
		
		# Sets the load index
		#
		# Returns nothing
		def setLoadIndex( an_integer )
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
			if format0RegEx.match(line_of_text)
			
			# check if 'keyword RD RA RB' instruction format consumes line
			# dispatch with information from named captures
			elsif format1RegEx.match(line_of_text)
			
			# check if 'keyword RD RA literal' instruction format consumes line
			# dispatch with information from named captures
			elsif format2RegEx.match(line_of_text)
			
			# check if 'keyword RD literal' instruction format consumes line
			# dispatch with information from named captures
			elsif format3RegEx.match(line_of_text)
			
			# check if 'keyword RD literal RA' instruction format consumes line
			# dispatch with information from named captures
			elsif format4RegEx.match(line_of_text)
			
			# check if '# memory_location_literal = memory_value_literal' directive consumes line
			# dispatch with information from named captures
			elsif dev0RegEx.match(line_of_text)
			
			# check if '# memory_location_literal = asm' directive consumes line
			# dispatch with information from named captures
			elsif dev1RegEx.match(line_of_text)
			
			# check if '//' format consumes line
			# ignore by doing nothing
			elsif commentRegEx.match(line_of_text)

			elsif whiteRegEx.match(line_of_text)

			
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
			# TODO implement this
			self.the_virtual_
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA( keyword ,dest_reg ,reg_a )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a, literal
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_literal( keyword ,dest_reg ,reg_a ,literal )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_literal_RA( keyword ,dest_reg ,literal ,reg_a )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal
		# DOCIT
		# # Returns nothing
		def instruction_format__keyword_RD_literal( keyword ,dest_reg ,literal )
			# TODO implement this
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = memory_value_literal
		# DOCIT
		#
		# Returns nothing
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			# TODO implement this
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = asm
		# DOCIT
		#
		# Returns nothing
		def directive__asm( memory_location_literal )
			# TODO implement this
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
