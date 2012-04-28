# this file contains refactored boilerplate code; homeless but common code
require	'Asm/require_all.rb'

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
	# module Boilerplate contains refactored boilerplate code that still doesn't have a home anywhere else.
	module Boilerplate
		# paranoid typechecking boilerplate
		#
		# argument - an object whose type is being checked
		# type - the type which argument's type must be for the check to not fail.
		#
		# Rasies exception when the check fails.
		# Returns nothing.
		def	raise_unless_type( argument ,type )
			raise "argument's type is " << argument.kind?() << ", not " << type.inspect() << "." unless argument.kind? == type
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
	end
end