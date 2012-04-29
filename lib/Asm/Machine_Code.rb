# encoding: UTF-8
# OH HAI! 
# キタ━━━(゜∀゜)━━━!!!!! 

module Asm
    class MachineCode
		# OpCodes
		ISA_MOVE  = 0
		ISA_NOT   = 1
		ISA_AND   = 2
		ISA_OR    = 3
		ISA_ADD   = 4
		ISA_SUB   = 5
		ISA_ADDI  = 6
		ISA_SUBI  = 7
		ISA_SET   = 8
		ISA_SETH  = 9
		ISA_INCIZ = 10
		ISA_DECIN = 11
		ISA_MOVEZ = 12
		ISA_MOVEX = 13
		ISA_MOVEP = 14
		ISA_MOVEN = 15
		
		# Hash of binary instructions
		ins = {'move'  => ISA_MOVE.to_s(2),
			   'not'   => ISA_NOT.to_s(2),
			   'and'   => ISA_AND.to_s(2),
			   'or'    => ISA_OR.to_s(2),
			   'add'   => ISA_ADD.to_s(2),
			   'sub'   => ISA_SUB.to_s(2),
			   'addi'  => ISA_ADDI.to_s(2),
			   'subi'  => ISA_SUBI.to_s(2),
			   'set'   => ISA_SET.to_s(2),
			   'seth'  => ISA_SETH.to_s(2),
			   'inciz' => ISA_INCIZ.to_s(2),
			   'decin' => ISA_DECIN.to_s(2),
			   'movez' => ISA_MOVEZ.to_s(2),
			   'movex' => ISA_MOVEX.to_s(2),
			   'movep' => ISA_MOVEP.to_s(2),
			   'moven' => ISA_MOVEN.to_s(2)
		}

		def initialize(mcode, offset)
			@mcode = mcode
			@offset = offset
			ins.each do |key ,value|
				
			#end
			#def ???( integer )
		#		text = integer.to_s
			#	while text.size < Asm::Magic::Memory::Bits_per::Quarterword
			#		text	= '0' << text
		#		end
	#		end
		end

		def to_s
			"offset: #{offset}, code: #{mcode}"
		end

		attr_reader :mcode, :offset
    end
end
