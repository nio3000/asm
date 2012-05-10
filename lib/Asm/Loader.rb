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
			if	!Asm::Magic::Loader::Load::Index.valid?( self.load_index )
				raise Asm::Boilerplate::Exception::Syntax.new( 'invalid load index state; directives following "# loc = asm" invalidate the load index state.' )
			end
			# return the Asm::BCPU::Memory::Location corresponding to the load index
			return	Asm::BCPU::Memory::Location.new( self.load_index )
		end
		# Increment the load index OR
		# raise error if load index is a invalid value
		# Returns nothing
		def incrementLoadIndex
			# if the load index is in an invalid state when this method is called, raise an error
			if	!Asm::Magic::Loader::Load::Index.valid?( self.load_index )
				raise Asm::Boilerplate::Exception::Syntax.new( 'invalid load index state; directives following "# loc = asm" invalidate the load index state.' )
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
			if	!Asm::Magic::Loader::Load::Index.valid?( an_integer )
				raise Asm::Boilerplate::Exception::Syntax.new( "invalid attempt to set load index state; \"#{an_integer.to_s}\" is not a valid index for a memory location." )
			else
				self.load_index	= an_integer
			end
			return
		end
		# DOCIT
		def word_from_register_literal( a_register_literal )
			# TODO refactor these & merge with other regex constants
			#register_flag	= 'd{,1}'
			#base10_number	= '[+\-]{,1}[0-9]+'
			#register_literal	= '^' << '(?<flag>' << register_flag << ')' << '(?<value>' << base10_number << ')' << '$'
			#
			#capture_register_literal	= ::Asm::Magic::Regexp.create( register_literal )
			#capture_register_literal	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String.consume_capture( ::Asm::Magic::Regexp::String::Asm::Register::Capture::Flag_Value ) )
			capture_register_literal	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Register::Capture::Flag_Value )
			match_info	= capture_register_literal.match( a_register_literal )
			raise "register literal expected from \"#{a_register_literal}\"" if !match_info
			result	= Asm::BCPU::Word.new( )
			result.assign_decimal_String( match_info[::Asm::Magic::Regexp::String::Names::Value] ,false )
			return	result
		end
		# DOCIT
		def word_from_numeric_literal( a_numeric_literal )
			# TODO refactor these & merge with other regex constants
			#binary_flag	= '0[bB]'
			#binary_number	= '[01]+'
			#base10_flag	= 'd{,1}'
			#base10_number	= '[+\-]{,1}[0-9]+'
			#binary_literal	= '^' << '(?<flag>' << binary_flag << ')' << '(?<value>' << binary_number << ')$'
			#decimal_literal	= '^' << '(?<flag>' << decimal_flag << ')' << '(?<value>' << decimal_number << ')$'
			#
			#binary_match_info	= ::Asm::Magic::Regexp.create( binary_literal ).match( a_numeric_literal )
			binary_match_info	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String.consume_capture( ::Asm::Magic::Regexp::String::Asm::Binary::Capture::Flag_Value ) ).match( a_numeric_literal )
			#decimal_match_info	= ::Asm::Magic::Regexp.create( decimal_literal ).match( a_numeric_literal )
			decimal_match_info	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String.consume_capture( ::Asm::Magic::Regexp::String::Asm::Base10::Capture::Flag_Value ) ).match( a_numeric_literal )
			#
			result	= Asm::BCPU::Word.new( )
			if !binary_match_info && decimal_match_info
				result.assign_decimal_String( decimal_match_info[::Asm::Magic::Regexp::String::Names::Value] )
			elsif binary_match_info && !decimal_match_info
				result.assign_binary_String( binary_match_info[::Asm::Magic::Regexp::String::Names::Value].reverse )
			elsif binary_match_info && decimal_match_info
				raise "decimal or binary literal expected from \"#{a_numeric_literal}\", but it\'s too ambiguous to tell which"
			else
				raise "decimal or binary literal expected from \"#{a_numeric_literal}\""
			end
			return	result
		end
		# DOCIT
		def location_from_numeric_literal( a_numeric_literal )
			# TODO refactor these & merge with other regex constants
			#binary_flag	= '0[bB]'
			#binary_number	= '[01]+'
			#base10_flag	= 'd{,1}'
			#base10_number	= '[+\-]{,1}[0-9]+'
			#binary_literal	= '^' << '(?<flag>' << binary_flag << ')' << '(?<value>' << binary_number << ')$'
			#decimal_literal	= '^' << '(?<flag>' << decimal_flag << ')' << '(?<value>' << decimal_number << ')$'
			#
			#binary_match_info	= ::Asm::Magic::Regexp.create( binary_literal ).match( a_numeric_literal )
			#decimal_match_info	= ::Asm::Magic::Regexp.create( decimal_literal ).match( a_numeric_literal )
			binary_match_info	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String.consume_capture( ::Asm::Magic::Regexp::String::Asm::Binary::Capture::Flag_Value ) ).match( a_numeric_literal )
			decimal_match_info	= ::Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String.consume_capture( ::Asm::Magic::Regexp::String::Asm::Base10::Capture::Flag_Value ) ).match( a_numeric_literal )
			#
			result	= Asm::BCPU::Memory::Location.new( )
			if !binary_match_info && decimal_match_info
				result.assign_decimal_String( decimal_match_info[::Asm::Magic::Regexp::String::Names::Value] ,false )
			elsif binary_match_info && !decimal_match_info
				result.assign_binary_String( binary_match_info[::Asm::Magic::Regexp::String::Names::Value] )
			elsif binary_match_info && decimal_match_info
				raise 'decimal or binary literal expected from "' << a_numeric_literal << '", but it\'s too ambiguous to tell which'
			else
				raise 'decimal or binary literal expected from "' << a_numeric_literal << '"'
			end
			return	result
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
			puts '#map_bits_to_bits,args |-> from_Range = ' << from_Range.to_s << '; to_Range = ' << to_Range.to_s << ''
			puts '#map_bits_to_bits,args |-> from_Word = ' << from_Word.to_s << '; to_Word = ' << to_Word.to_s << ''
			# paranoid type checking
			Asm::Boilerplate::raise_unless_type( from_Range ,::Range )
			Asm::Boilerplate::raise_unless_type( to_Range ,::Range )
			Asm::Boilerplate::raise_unless_type( from_Word ,::Asm::BCPU::Word )
			if	!to_Word.instance_of?( ::Asm::BCPU::Word ) && !to_Word.instance_of?( ::Asm::BCPU::Memory::Value ) && !to_Word.instance_of?( ::Asm::BCPU::Memory::Location )
				Asm::Boilerplate::raise_unless_type( to_Word ,::Asm::BCPU::Word )
			end
			# paranoid range checking
			#raise ('shenanigans; \'' << (from_Word.the_bits.size - 1).to_s << '\' is not in \''<< from_Range.to_s << '\'') unless from_Range.include?( from_Word.the_bits.size - 1 )
			#raise ('shenanigans; \'' << (to_Word.the_bits.size - 1).to_s << '\' is not in \''<< to_Range.to_s << '\'') unless to_Range.include?( to_Word.the_bits.size - 1 )
			raise 'invalid mapping' unless	((from_Range.last - from_Range.first) == (to_Range.last - to_Range.first))
			# BCPU range checking
			if bCPU_range_checking
				(0..(Asm::Magic::Memory::Bits_per::Word - 1)).each do |from_index|
					if !(from_Range.include?( from_index )) && (from_Word.the_bits[from_index] == true )
						raise Asm::Boilerplate::Exception::Overflow.new( 'literal translated to binary value requiring more bits than available in the context; "' << from_Word.to_s << "' outside of supported range, '" << from_Range.to_s << "'; first invalid value is at index " << from_index.to_s << '.' )
						raise Asm::Boilerplate::Exception::Syntax.new( "literal translates to binary value, '" << from_Word.to_s << "' outside of supported range, '" << from_Range.to_s << "'; first invalid value is at index " << from_index.to_s << '.' )
					end
				end
			end
			# do the mapping
			adjustment	= to_Range.begin - from_Range.begin
			to_range_index	= 0
			from_Range.each do |from_index|
				to_index	= ::Asm::Boilerplate.socks!( to_Range, to_range_index )
				raise 'shenanigans' unless to_Range.include?( to_index )
				puts '' << ((to_Word.the_bits[to_index])?('true'):('false'))	<< '[' << to_index.to_s << ']=' << ((from_Word.the_bits[from_index])?('true'):('false'))	<< '[' << from_index.to_s << ']'
				to_Word.the_bits[to_index]	= from_Word.the_bits[from_index]
				to_Word.the_bits[to_index]	= ((from_Word.the_bits[from_index])?(true):(false))
				puts '' << ((to_Word.the_bits[to_index])?('true'):('false'))
				to_range_index	= to_range_index + 1
			end
			puts '#map_bits_to_bits |-> from_Word = ' << from_Word.to_s << '; to_Word = ' << to_Word.to_s << ''
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
						messages.push 'syntax error on line' << line_count.to_s << ": \"" << a_syntax_error.message << "\""
					rescue Asm::Boilerplate::Exception::Overflow => an_overflow_error
						messages.push 'overflow error on line' << line_count.to_s << ": \"" << an_overflow_error.message << "\""
					rescue ::Exception => an_error
						messages.push 'unexpected error on line' << line_count.to_s << ": \"" << an_error.message << "\" " << an_error.backtrace.to_s
					rescue ::String => an_error
						messages.push 'unexpected error on line' << line_count.to_s << ": \"" << an_error.message << "\""
					end
					puts 'DEBUG: load index after line ' << line_count.to_s << ' is ' << self.load_index.to_s << '.'
				end
			else
				messages.push '\'' << path << '\' is not a file.'
			end
			messages
		end
	#private
	public
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
=begin
			puts ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA	# check if 'keyword RD RA' instruction format consumes line
			puts ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_RB
			puts ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_data
			puts ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data
			puts ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data_RB
			puts ::Asm::Magic::Regexp::String::Asm::Directive::Format::Assignment
			puts ::Asm::Magic::Regexp::String::Asm::Directive::Format::Asm
			puts ::Asm::Magic::Regexp::String::Asm::Ignore::Comment
			puts ::Asm::Magic::Regexp::String::Asm::Ignore::Blank

			puts capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA ).match(line_of_text)	# check if 'keyword RD RA' instruction format consumes line
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_RB ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_data ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data_RB ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Assignment ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Asm ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Comment ).match(line_of_text)
			puts  capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Blank ).match(line_of_text)
=end
			capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA ).match(line_of_text)	# check if 'keyword RD RA' instruction format consumes line
			if	capture != nil
				self.instruction_format__keyword_RD_RA( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A] )
			else
				capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_RB ).match(line_of_text)
				if	capture != nil
					self.instruction_format__keyword_RD_RA_RB( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A], capture[::Asm::Magic::Regexp::String::Names::Register::B] )
				else
					capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_data ).match(line_of_text)
					if	capture != nil
						self.instruction_format__keyword_RD_RA_literal( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A], capture['literal'])
					else
						capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data ).match(line_of_text)
						if	capture != nil
							self.instruction_format__keyword_RD_literal( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Numeric::Literal])
						else
							capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data_RB ).match(line_of_text)
							if	capture != nil
								self.instruction_format__keyword_RD_literal_RA( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Numeric::Literal], capture[::Asm::Magic::Regexp::String::Names::Register::B])
							else
								capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Assignment ).match(line_of_text)
								if	capture != nil
									self.directive__memory_value(capture[::Asm::Magic::Regexp::String::Names::Directive::LHS], capture[::Asm::Magic::Regexp::String::Names::Directive::RHS])
								else
									capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Asm ).match(line_of_text)
									if	capture != nil
										self.directive__asm( capture[::Asm::Magic::Regexp::String::Names::Directive::LHS] )
									else
										capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Comment ).match(line_of_text)
										if	capture != nil
											;
										else
											capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Blank ).match(line_of_text)
											if	capture != nil
												;
											else
												raise Asm::Boilerplate::Exception::Syntax.new( 'this is not BCPU assembly; Loader refuses to do anything with this.' )
											end
										end
									end
								end
							end
						end
					end
				end
			end
=begin
			#if capture = format0RegEx.match(line_of_text)	# check if 'keyword RD RA' instruction format consumes line
			if capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA ).match(line_of_text)	# check if 'keyword RD RA' instruction format consumes line
				# dispatch with information from named captures
				self.instruction_format__keyword_RD_RA( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A] )
			# check if 'keyword RD RA RB' instruction format consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_RB ).match(line_of_text)
				# dispatch with information from named captures
				self.instruction_format__keyword_RD_RA_RB( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A], capture[::Asm::Magic::Regexp::String::Names::Register::B] )
			# check if 'keyword RD RA literal' instruction format consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_RA_data ).match(line_of_text)
				# dispatch with information from named captures
				self.instruction_format__keyword_RD_RA_literal( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Register::A], capture['literal'])
			# check if 'keyword RD literal' instruction format consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data ).match(line_of_text)
				# dispatch with information from named captures
				self.instruction_format__keyword_RD_literal( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Numeric::Literal])
			# check if 'keyword RD literal RA' instruction format consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Instruction::Format::RD_data_RB ).match(line_of_text)
				# dispatch with information from named captures
				self.instruction_format__keyword_RD_literal_RA( capture[::Asm::Magic::Regexp::String::Names::Keyword], capture[::Asm::Magic::Regexp::String::Names::Register::D], capture[::Asm::Magic::Regexp::String::Names::Numeric::Literal], capture[::Asm::Magic::Regexp::String::Names::Register::B])
			# check if '# memory_location_literal = memory_value_literal' directive consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Assignment ).match(line_of_text)
				# dispatch with information from named captures
				self.directive__memory_value(capture[::Asm::Magic::Regexp::String::Names::Directive::LHS], capture[::Asm::Magic::Regexp::String::Names::Directive::RHS])
			# check if '# memory_location_literal = asm' directive consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Directive::Format::Asm ).match(line_of_text)
				# dispatch with information from named captures
				self.directive__asm( capture[::Asm::Magic::Regexp::String::Names::Directive::LHS] )
			# check if '//' format consumes line
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Comment ).match(line_of_text)
				# ignore by doing nothing
			elsif capture = Asm::Magic::Regexp.create( ::Asm::Magic::Regexp::String::Asm::Ignore::Blank ).match(line_of_text)
				# ignore by doing nothing
			else
				# syntax error
				raise Asm::Boilerplate::Exception::Syntax.new( 'this is not BCPU assembly; Loader refuses to do anything with this.' )
			end
=end
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg reg_a reg_b
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_RB( keyword ,dest_reg ,reg_a ,reg_b )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( keyword ,::String )
			Asm::Boilerplate::raise_unless_type( dest_reg ,::String )
			Asm::Boilerplate::raise_unless_type( reg_a ,::String )
			Asm::Boilerplate::raise_unless_type( reg_b ,::String )
			#
			keyword.upcase!
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			wordRB = self.word_from_register_literal(reg_b)
			value = Asm::BCPU::Memory::Value.new
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( wordRD ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordRA ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordRB ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( value ,::Asm::BCPU::Memory::Value )
			#
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRD, 8..11, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRA, 4..7, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRB, 0..3, value)

			if keyword == 'AND'
				value.the_bits[13] = true
			elsif keyword == 'OR'
				value.the_bits[12] = true
				value.the_bits[13] = true
			elsif keyword == 'ADD'
				value.the_bits[14] = true
			elsif keyword == 'SUB'
				value.the_bits[14] = true
				value.the_bits[12] = true
			elsif keyword == 'MOVEZ'
				value.the_bits[15] = true
				value.the_bits[14] = true
			elsif keyword == 'MOVEX'
				value.the_bits[15] = true
				value.the_bits[14] = true
				value.the_bits[12] = true
			elsif keyword == 'MOVEP'
				value.the_bits[15] = true
				value.the_bits[14] = true
				value.the_bits[13] = true
			elsif keyword == 'MOVEN'
				value.the_bits[15] = true
				value.the_bits[14] = true
				value.the_bits[13] = true
				value.the_bits[12] = true
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognized operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			puts '#instruction_format__keyword_RD_RA_RB, location = ' << location.to_s << ';value = ' << value.to_s
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA( keyword ,dest_reg ,reg_a )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( keyword ,::String )
			Asm::Boilerplate::raise_unless_type( dest_reg ,::String )
			Asm::Boilerplate::raise_unless_type( reg_a ,::String )
			#
			keyword.upcase!
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			value = Asm::BCPU::Memory::Value.new
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( wordRD ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordRA ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( value ,::Asm::BCPU::Memory::Value )

			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRD, 8..11, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRA, 4..7, value)

			if keyword == 'MOVE'
				#Nothing to do, Opcode: 0000
			elsif keyword == 'NOT'
				value.the_bits[12] = true
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			puts '#instruction_format__keyword_RD_RA, location = ' << location.to_s << ';value = ' << value.to_s
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, reg_a, literal
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_literal( keyword ,dest_reg ,reg_a ,literal )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( keyword ,::String )
			Asm::Boilerplate::raise_unless_type( dest_reg ,::String )
			Asm::Boilerplate::raise_unless_type( literal ,::String )
			Asm::Boilerplate::raise_unless_type( reg_a ,::String )

			keyword.upcase!
			wordRD = self.word_from_register_literal(dest_reg)
			wordRA = self.word_from_register_literal(reg_a)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BCPU::Memory::Value.new
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( wordRD ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordRA ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordLit ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( value ,::Asm::BCPU::Memory::Value )
			#
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRD, 8..11, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRA, 4..7, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordLit, 0..3, value)

			if keyword == 'ADDI'
				value.the_bits[13] = true
				value.the_bits[14] = true
			elsif keyword == 'SUBI'
				value.the_bits[13] = true
				value.the_bits[14] = true
				value.the_bits[12] = true
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			puts '#instruction_format__keyword_RD_RA_literal, location = ' << location.to_s << ';value = ' << value.to_s
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal, reg_a
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_literal_RA( keyword ,dest_reg ,literal ,reg_a )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( keyword ,::String )
			Asm::Boilerplate::raise_unless_type( dest_reg ,::String )
			Asm::Boilerplate::raise_unless_type( literal ,::String )
			Asm::Boilerplate::raise_unless_type( reg_a ,::String )
			#
			keyword.upcase!
			wordRD = self.word_from_register_literal(dest_reg)
			wordRB = self.word_from_register_literal(reg_a)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BCPU::Memory::Value.new
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( wordRD ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordRB ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordLit ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( value ,::Asm::BCPU::Memory::Value )
			#
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRD, 8..11, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRB, 0..3, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordLit, 4..7, value)

			if keyword == 'INCIZ'
				value.the_bits[13] = true
				value.the_bits[14] = true
			elsif keyword == 'DECIN'
				value.the_bits[13] = true
				value.the_bits[14] = true
				value.the_bits[12] = true
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			puts '#instruction_format__keyword_RD_literal_RA, location = ' << location.to_s << ';value = ' << value.to_s
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword dest_reg, literal
		# DOCIT
		# # Returns nothing
		def instruction_format__keyword_RD_literal( keyword ,dest_reg ,literal )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( keyword ,::String )
			Asm::Boilerplate::raise_unless_type( dest_reg ,::String )
			Asm::Boilerplate::raise_unless_type( literal ,::String )
			#
			keyword.upcase!
			wordRD = self.word_from_register_literal(dest_reg)
			wordLit = self.word_from_numeric_literal(literal)
			value = Asm::BCPU::Memory::Value.new
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( wordRD ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( wordLit ,::Asm::BCPU::Word )
			Asm::Boilerplate::raise_unless_type( value ,::Asm::BCPU::Memory::Value )
			#
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..3 ), wordRD, 8..11, value)
			self.map_bits_to_bits( ::Asm::Boilerplate.pads!( 0..7 ), wordLit, 0..7, value)
			if keyword == 'SET'
				value.the_bits[13] = true
				value.the_bits[14] = true
			elsif keyword == 'SETH'
				value.the_bits[13] = true
				value.the_bits[14] = true
				value.the_bits[12] = true
			else
				raise Asm::Boilerplate::Exception::Syntax.new( 'Keyword [' + keyword + '] is not a recognize operation' )
			end
			self.incrementLoadIndex()
			location = self.getLocationFromLoadIndex()
			puts "#instruction_format__keyword_RD_literal, location = #{location.to_s}; value = #{value.to_s}"
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = memory_value_literal
		# DOCIT
		#
		# Returns nothing
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( memory_location_literal ,::String )
			Asm::Boilerplate::raise_unless_type( memory_value_literal ,::String )
			#
			location = self.location_from_numeric_literal(memory_location_literal)
			wordLit = self.word_from_numeric_literal( memory_value_literal )
			value = Asm::BCPU::Memory::Value.new( wordLit.the_bits )

			puts "location.to_s=\"#{location.to_s}\"; value.to_s=\"#{value.to_s}\";" # confirmed that location and value have the correct content.
			self.the_Virtual_Machine.set_location_to_value(location, value)
			return
		end
		# initialize the VM
		# handles BCPU assembly syntax case: # memory_location_literal = asm
		# DOCIT
		#
		# Returns nothing
		def directive__asm( memory_location_literal )
			# Paranoid type checking
			Asm::Boilerplate::raise_unless_type( memory_location_literal ,::String )
			#
			location = self.location_from_numeric_literal(memory_location_literal)
			self.setLoadIndex( location.to_i )
			return
		end
	end
end

# encoding: UTF-8
