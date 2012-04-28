# encoding: UTF-8

=begin
# /lib/Asm/Boilerplate.rb
* refactored boilerplate code living under module Asm::Boilerplate
=end

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin	# Asm::Boilerplate
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
=begin	# Asm::Boilerplate::Bitset
=end
		module Bitset
			# boilerplate for resizing an instance of Bitset
			def	resize( Desired_size )
				# TODO implement this
			end
		end
	end
end

require	'Asm/require_all.rb'
