=begin
# /lib/Asm/Boilerplate.rb
* refactored boilerplate code living under module Asm::Boilerplate
=end
require	'Asm/require_all.rb'

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin	# Asm::Boilerplate
=end	module Boilerplate
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