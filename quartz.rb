#!/usr/bin/ruby

class	Program_Options
end

class	Application
end

module	BCPU
	# a Loader instance initializes a Virtual_Machine instance's memory.
	class	Loader
		# Public: get & set the_Virtual_Machine associated with this instance.
		attr_accessor :the_Virtual_Machine
		# Public: initialize Loader instance with reference to a Virtual_Machine
		#
		# the_Virtual_Machine	- reference to a Virtual_Machine instance
		def initialize( the_Virtual_Machine )
			raise "argument was not a reference to a BCPU.Virtual_Machine" unless the_Virtual_Machine.kind? == BCPU.Virtual_Machine
			@the_Virtual_Machine	= the_Virtual_Machine
		end
		attr_accessor :passive_target
		# Public: invoke Loader instance with a given file of BCPU assembly
		def load( file )
			...
			for each line in file,
				classify the line
					Regexp match, y/n
					context appropriate, y/n
				obtain the relevant info from the line
					Regex match, named captures
					valid, y/n
				pass that information to Loader.relevant functionality.
					do it
					valid, y/n
		end
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__memory_value( memory_location_literal ,memory_value_literal )
			...
		end
		# Private: given ???, do ???; for invalid literals, do ???
		def directive__asm( memory_location_literal )
			...
		end
	end

	# a Virtual_Machine instance preserves the internal state of a BCPU and can simulate that BCPU excution affects its internal state.
	class	Virtual_Machine
	end
end









# Internal: Create a Regexp instance that will named-capture any literal's flag & value.
#
# flag_capture_name  - matched literal's flag's capture name.
# value_capture_name - matched literal's value's capture name.
#
# Examples
#
#   literal_named_capture_Regexp( 'Miku' ,'Chado' ).match( '0b0' )['Miku']
#   # => '0b'
#
# Returns the created Regexp instance.
def	literal_named_capture_Regexp( flag_capture_name ,value_capture_name )
