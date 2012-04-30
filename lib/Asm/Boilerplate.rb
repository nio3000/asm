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
    module Boilerplate
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Rasies exception when the check fails.
		# Returns nothing.
		def	raise_unless_type( argument ,type )
			raise "argument's type is " << argument.kind?() << ", not " <<
                type.inspect() << "." unless argument.kind? == type
			return
		end
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Returns true iff arugment is of type type.
		def	true_if_type( argument ,type )
			return	argument.kind? == type
		end
=begin
        # Asm::Boilerplate::Bitset
=end
		module Bitset
			# boilerplate for resizing an instance of Bitset
			def	resize( desired_size )
				# TODO implement this
			end
		end
=begin
        # Asm::Boilerplate::Exception
=end
		class Exception
=begin
        # Asm::Boilerplate::Exception::Syntax
		* if code generates a BCPU assembly syntax error,
            then raise an exception of this type with a message explaining the error
		* you don't need to add line number information,
            that happens when the Syntax object is rescued
		* example: `raise Asm::Boilerplate::Exception::Syntax.new( 'gibberish input; not an instruction, directive, comment, or blank line.' )`
=end
			class Syntax < Exception
			end
=begin
            # Asm::Boilerplate::Exception::Overflow
			* DOCIT
=end
			class Overflow < Exception
			end
		end
    end
end

#require	'Asm/require_all.rb'
$LOAD_PATH << '.'
# encoding: UTF-8
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=ruby
