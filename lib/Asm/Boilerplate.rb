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
		# DOCIT
		# strings got padded, this is a hotfix
		def	self.pads!( a_Range )
			offset	= (::Asm::Magic::Memory::Bits_per::Word - 1)
			return	(offset - a_Range.last)..(offset - a_Range.first)
		end
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Rasies exception when the check fails.
		# Returns nothing.
		def	self.raise_unless_type( argument ,type )
			#raise "argument's type is " << argument.kind?() << ", not " << type.inspect() << "." unless argument.kind? == type
			begin
				raise 'argument\'s type is ' << argument.kind?() << ', not ' << type.inspect() << '; argument.inspect gives \'' << argument.inspect( ) << '\'.' unless argument.instance_of?( type )
			rescue
				raise 'argument\'s type is not ' << type.inspect() << '; argument.inspect gives \'' << argument.inspect( ) << '\'.' unless argument.instance_of?( type )
			end
			return
		end
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Returns true iff arugment is of type type.
		#def	self.true_if_type( argument ,type )
		#	return	argument.kind_of? type
		#end
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
		end
	end
end

# encoding: UTF-8
