module Asm::Magic::Regexp::String::Asm::Keyword::Array
	RD_RA      = [:MOVE, :NOT]
	RD_RA_RB   = [:AND, :OR, :ADD, :SUB, :MOVEZ, :MOVEX, :MOVEP, :MOVEN]
	RD_RA_data = [:ADDI, :SUBI]
	RD_data_RB = [:INCIZ, :DECIN]
	RD_data    = [:SET, :SETH]
end

module Asm::Boilerplate::Machine
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

module VM
	include Asm::Magic::Regexp::String::Asm::Keyword::Array
	include Asm::Boilerplate::Machine

	rd = lambda { |mc| Code.get_RD_location( mc ) }
	ra = lambda { |mc| Code.get_RA_location( mc ) }
	rb = lambda { |mc| Code.get_RB_location( mc ) }
	bit = lambda { |mc, range| Code.get_value_from_bit_range( mc, range ) }

	opcode_key = (Asm::Magic::ISA::Opcode::Binary::String.key(op_code_binary_string)).to_s
	if RD_RA.include? op_code_binary_string
	   eval "self.#{opcode_key.downcase}(rd(the_machine_code), ra(the_machine_code))"
	elsif RD_RA_RB.include? op_code_binary_string
	   eval "self.#{opcode_key.downcase}(rd(the_machine_code), ra(the_machine_code), rb(the_machine_code))"
	elsif RD_RA_data.include? op_code_binary_string
	   eval "self.#{opcode_key.downcase}(rd(the_machine_code), ra(the_machine_code), bit(the_machine_code, (0..3)))"
	elsif RD_data_RB.include? op_code_binary_string
	   eval "self.#{opcode_key.downcase}(rd(the_machine_code), bit(the_machine_code, (4..7)), ra(the_machine_code))"
	elsif RD_data.include? op_code_binary_string
		eval "self.#{opcode_key.downcase}(rd(the_machine_code), bit(the_machine_code, (0..7)))"
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
