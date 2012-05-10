module Asm
	module Magic
		module Regexp
			module String
				module Asm
					module Keyword
						module Array
							RD_RA      = [:MOVE, :NOT]
							RD_RA_RB   = [:AND, :OR, :ADD, :SUB, :MOVEZ, :MOVEX, :MOVEP, :MOVEN]
							RD_RA_data = [:ADDI, :SUBI]
							RD_data_RB = [:INCIZ, :DECIN]
							RD_data    = [:SET, :SETH]
						end
					end
				end
			end
		end
		module ISA
			module Opcode
				module Integer
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
				end

				module Binary
					include Asm::Magic::ISA
					opcodes = Opcode::Integer.constants
					binary = lambda { |x| x.to_s(2).rjust(4,'0') }
					String = Hash.new
					opcodes.each do |code|
						String[code] = binary.call(Opcode::Integer.const_get(code))
					end
				end
			end
		end
	end
	module Boilerplate
		module Machine
			module Code
				def get_RD_location(code)
					puts "location for #{code}"
				end
				def get_RA_location(code)
					puts "location for #{code}"
				end
				def get_RB_location(code)
					puts "location for #{code}"
				end
				def get_value_from_bit_range(code, range)
					puts "location for #{code} at #{range}"
				end
			end
		end
	end
end


module Asm::Virtual_Machine
	include Asm::Magic::Regexp::String::Asm::Keyword::Array
	include Asm::Boilerplate::Machine

	def refactor(op_code_binary_string, the_machine_code)
		rd = lambda { |mc| Code.get_RD_location( mc ) }
		ra = lambda { |mc| Code.get_RA_location( mc ) }
		rb = lambda { |mc| Code.get_RB_location( mc ) }
		bit = lambda { |mc, range| Code.get_value_from_bit_range( mc, range ) }

		opcode_key = (Asm::Magic::ISA::Opcode::Binary::String.key(op_code_binary_string)).to_s
		puts opcode_key
		if RD_RA.include? op_code_binary_string
		   puts "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code))"
		   eval "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code))"
		elsif RD_RA_RB.include? op_code_binary_string
		   puts "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code), rb.call(the_machine_code))"
		   eval "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code), rb.call(the_machine_code))"
		elsif RD_RA_data.include? op_code_binary_string
		   puts "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code), bit.call(the_machine_code, (0..3)))"
		   eval "self.#{opcode_key.downcase}(rd.call(the_machine_code), ra.call(the_machine_code), bit.call(the_machine_code, (0..3)))"
		elsif RD_data_RB.include? op_code_binary_string
		   puts "self.#{opcode_key.downcase}(rd.call(the_machine_code), bit.call(the_machine_code, (4..7)), ra.call(the_machine_code))"
		   eval "self.#{opcode_key.downcase}(rd.call(the_machine_code), bit.call(the_machine_code, (4..7)), ra.call(the_machine_code))"
		elsif RD_data.include? op_code_binary_string
			puts "self.#{opcode_key.downcase}(rd.call(the_machine_code), bit.call(the_machine_code, (0..7)))"
			eval "self.#{opcode_key.downcase}(rd.call(the_machine_code), bit.call(the_machine_code, (0..7)))"
		end

		return 'failure'
	end

	def move(rd, ra)
		puts "move #{rd} #{ra}"
	end

	def not(rd, ra)
		puts "not #{rd} #{ra}"
	end

	def and(rd, ra, rb)
		puts "and #{rd} #{ra} #{rb}"
	end

	def or(rd, ra, rb)
		puts "or #{rd} #{ra} #{rb}"
	end

	def add(rd, ra, rb)
		puts "add #{rd} #{ra} #{rb}"
	end

	def sub(rd, ra, rb)
		puts "sub #{rd} #{ra} #{rb}"
	end

	def movez(rd, ra, rb)
		puts "movez #{rd} #{ra} #{rb}"
	end

	def movex(rd, ra, rb)
		puts "movex #{rd} #{ra} #{rb}"
	end

	def movep(rd, ra, rb)
		puts "movep #{rd} #{ra} #{rb}"
	end

	def moven(rd, ra, rb)
		puts "moven #{rd} #{ra} #{rb}"
	end

	def addi(rd, ra, data)
		puts "addi #{rd} #{ra} #{data}"
	end

	def subi(rd, ra, data)
		puts "subi #{rd} #{ra} #{data}"
	end

	def inciz(rd, data, rb)
		puts "inciz #{rd} #{data} #{rb}"
	end

	def decin(rd, data, rb)
		puts "decin #{rd} #{data} #{rb}"
	end

	def set(rd, data)
		puts "set #{rd} #{data}"
	end

	def seth(rd, data)
		puts "seth #{rd} #{data}"
	end
end

include Asm::Virtual_Machine
op_code = 0001
machine_code = 0000000000000001
refactor(op_code, machine_code)
