# encoding: UTF-8

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
			raise_unless_type( the_Virtual_Machine ,Asm::Virtual_Machine )
			# initialize all persistant member variables.
			@the_Virtual_Machine	= the_Virtual_Machine
			@load_index	= Asm::Literals_Are_Magic::Loader::example_invalid_load_index
		end
	public
=begin	interface related to telling the Loader to load into the virtual machine
=end
		# invoke Loader instance with a given file of BCPU assembly
		#
		# Returns an array of the first exception encountered for each line of text in the given file
		def load( Path )
			messages	= []
			line_count	= 0
			code	= File.open( Path ,'r' )
			# parse individually each line in the file
			code.each_line do |line|
				line_count += 1
				begin
					self.handle( line )
				rescue Asm::Boilerplate::Exception::Syntax => a_syntax_error
					messages.push 'syntax error on line' << line_count << ': \"' << a_syntax_error.message << '\"'
				else => an_error # TODO verify if this is appropriate or if this needs to be rescue Exception => ...
					messages.push 'unexpected error on line' << line_count << ': \"' << an_error.message << '\"'
				end
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
			# check if 'keyword RD RA RB' instruction format consumes line
			# dispatch with information from named captures
			
			# check if 'keyword RD RA' instruction format consumes line
			# dispatch with information from named captures
			
			# check if 'keyword RD literal' instruction format consumes line
			# dispatch with information from named captures
			
			# check if 'keyword RD literal RA' instruction format consumes line
			# dispatch with information from named captures
			
			# check if 'keyword RD RA literal' instruction format consumes line
			# dispatch with information from named captures
			
			# check if '# memory_location_literal = memory_value_literal' directive consumes line
			# dispatch with information from named captures
			
			# check if '# memory_location_literal = asm' directive consumes line
			# dispatch with information from named captures
			
			# check if '//' format consumes line
			# ignore by doing nothing
			
			# else
			raise Asm::Boilerplate::Exception::Syntax.new( 'this is not BCPU assembly; Loader refuses to do anything with this.' )
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword RD RA RB 
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_RB( keyword ,RD ,RA ,RB )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword RD, RA 
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA( keyword ,RD ,RA )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword RD, RA, literal
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_RA_literal( keyword ,RD ,RA ,literal )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword RD, literal, RA
		# DOCIT
		#
		# Returns nothing
		def instruction_format__keyword_RD_literal_RA( keyword ,RD ,literal ,RA )
			# TODO implement this
			return
		end
		# initialize the VM
		# dispatches BCPU assembly syntax case: # keyword RD, literal
		# DOCIT
		# # Returns nothing def instruction_format__keyword_RD_literal( keyword ,RD ,literal )
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
=end		class Test < Test::Unit::TestCase
		end
	end
end

require	'Asm/require_all.rb'
