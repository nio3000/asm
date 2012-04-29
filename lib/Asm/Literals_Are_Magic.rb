# encoding: UTF-8

=begin
# /lib/Asm/Literals_are_Magic.rb
* complete definition of module Asm::Magic and all nested modules thereof
=end

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
				Word	= 16	 # one word's worth of bits is the number of bits associated with a memory location or memory value
				Halfword	= 8
				Quarterword	= 4
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

        module ISA
            # Integer OpCodes
            MOVE  = 0
            NOT   = 1
            AND   = 2
            OR    = 3
            ADD   = 4
            SUB   = 5
            ADDI  = 6
            SUBI  = 7
            SET   = 8
            SETH  = 9
            INCIZ = 10
            DECIN = 11
            MOVEZ = 12
            MOVEX = 13
            MOVEP = 14
            MOVEN = 15

            # instructions and their 4 bit binary codes
            instructions = {'move'  => "%04d" % MOVE.to_s(2),
                            'not'   => "%04d" % NOT.to_s(2),
                            'and'   => "%04d" % AND.to_s(2),
                            'or'    => "%04d" % OR.to_s(2),
                            'add'   => "%04d" % ADD.to_s(2),
                            'sub'   => "%04d" % SUB.to_s(2),
                            'addi'  => "%04d" % ADDI.to_s(2),
                            'subi'  => "%04d" % SUBI.to_s(2),
                            'set'   => "%04d" % SET.to_s(2),
                            'seth'  => "%04d" % SETH.to_s(2),
                            'inciz' => "%04d" % INCIZ.to_s(2),
                            'decin' => "%04d" % DECIN.to_s(2),
                            'movez' => "%04d" % MOVEZ.to_s(2),
                            'movex' => "%04d" % MOVEX.to_s(2),
                            'movep' => "%04d" % MOVEP.to_s(2),
                            'moven' => "%04d" % MOVEN.to_s(2)}
            end
        end
	end
end

require	'Asm/require_all.rb'
