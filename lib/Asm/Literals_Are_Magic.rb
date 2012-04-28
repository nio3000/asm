=begin
# /lib/Asm/Literals_are_Magic.rb
* complete definition of module Asm::Magic and all nested modules thereof
=end

require	'Asm/require_all.rb'

module Asm

=begin 
    # Asm::Magic
	    * hardcoded immutable values # TODO figure out how to make them immutable
	## design choice
	* refactor multiple-word names into nested modules
		* indulge in ludicrously explanatory variable names
		* I don't care if it takes you forever to type the full nested name
		* this design choice is for reading them
=end	
    module Magic

=begin		# Asm::Magic::Loader
=end		
        module	Loader
			# a safe to use invalid load index that should be assigned anytime the Loader's load index needs to be in an invalid (unusable) state.
			# TODO remove explicit dependence on this variable.
			example_invalid_load_index	= Asm::Magic::Memory::Index::Exclusive::minimum
		end

=begin		# Asm::Magic::Memory
=end		

        module	Memory
=begin			# Asm::Magic::Memory::Bits_per
=end			

        module	Bits_per
				word	= 16	 # one word's worth of bits is the number of bits associated with a memory location or memory value
				halfword	= 8
				quarterword	= 4
		end
=begin			# Asm::Magic::Memory::Index
			* minimums & maximums in inclusive & exclusive flavours
=end			
        module	Index
				module	Inclusive
					minimum	= 0
					maximum	= 65535
				end
				module	Exclusive
					minimum	= Asm::Magic::Memory::Index::Inclusive::minimum - 1
					maximum	= Asm::Magic::Memory::Index::Inclusive::maximum + 1	# 2^16 = 65536
				end
			end
		end

=begin		# Asm::Magic::Register
=end		
        module	Register
=begin			# Asm::Magic::Register::Index
			* memory indicies of unique special function registers
			* minimums & maximums in inclusive & exclusive flavours
=end			
            module	Index
				program_counter	= Asm::Magic::Register::Index::Inclusive::maximum	# 15
				module	Inclusive
					minimum	= 0
					maximum	= 15
				end
				module	Exclusive
					minimum	= Asm::Magic::Register::Index::Inclusive::minimum - 1
					maximum	= Asm::Magic::Register::Index::Inclusive::maximum + 1	# 2^4 = 16
				end
			end
=begin		# Asm::Magic::Register::Indicies
			    * memory indicies of categories of special function registers
=end			
            module	Indicies
				input_registers	= [ 6 ]
				output_registers	= [ 13 ,14 ]
			end

=begin		# Asm::Magic::Register::Location
			    * memory locations of unique special function registers
=end			
            module	Location 
				program_counter	= Asm::BCPU::Memory::Location.new( Asm::Magic::Register::Index::program_counter )
			end

=begin			
            # Asm::Magic::Register::Locations
                * memory locations of ategories of special function registers
=end			
            module	Locations 
				input_registers	= Asm::Magic::Register::Indicies::input_registers.each { |index| Asm::BCPU::Memory::Location.new( index ) }
				output_registers	= Asm::Magic::Register::Indicies::output_registers.each { |index| Asm::BCPU::Memory::Location.new( index ) }
			end
		end
	end
end
