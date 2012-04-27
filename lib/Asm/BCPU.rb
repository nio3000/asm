# DOCIT

require	'Asm/require_all.rb'

# module Asm contains code relevant to the function of a BCPU VM.
module Asm
	# DOCIT
	module BCPU
		# DOCIT
		class	Word
			attr_reader :the_bits
			# DOCIT
			#
			# argument - DOCIT
			#
			# Raises exception when argument does not translate to a valid BCPU word
			# Initializes a new BCPU word
			def initialize( argument = nil )
				self.assign( argument )
			end
			# DOCIT
			def assign( argument = nil ,assume_unsigned = true )
				# Bitset initialized to 16 bits of zeros.
				self.the_bits	= Bitset.new( Asm::Literals_Are_Magic::Memory::bits_per_word )
				# using argument to set the bits
				if Asm::Boilerplate::true_if_type( argument ,String )
					# TODO implement this
					# convert decimal literals
					# convert binary literals 
					raise "hahaha"
				elsif Asm::Boilerplate::true_if_type( argument ,Integer )
					# convert Integers
					binary_value	= argument.to_s( )
					# TODO binary_value needs clean up; if Integer was < 0, then the formatting is wonky (see String's ruby docs), else it's probably fine
						# psst, abs( argument ) makes it positive; but you still need to set the sign bit and make sure its in the valid range for negative & twos complement
					partial_result	= Bitset.from_s( binary_value )
					#@the_bits | partial_result
					self.bitwise_OR( partial_result )
				elsif (Asm::Boilerplate::true_if_type( argument ,Bitset ) || Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Word ))
					self.bitwise_OR( argument )
				end
				return
			end
			# DOCIT
			def clone
				the_deep_copy	= self.new
				the_deep_copy.assign( self )
				return	the_deep_copy
			end
			# DOCIT
			def bitwise_OR( argument )
				# TODO verify this preserves size
				if Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Word )
					self.the_bits | argument.the_bits
				elsif Asm::Boilerplate::true_if_type( argument ,Bitset )
					self.the_bits | argument.the_bits
					# TODO | is broken when partial_result is less than @the)bits in length
				else
					raise "wtf; stop it"
					# TODO reduce exception boilerplate
				end
				return
			end
			# DOCIT
			def to_s( )
				# TODO implement this; assume literal interpretation (aka, just report the damn bits)
			end
		end
		# DOCIT
		module Memory
			# DOCIT
			class Location < Asm::BCPU::Word
				# DOCIT
				#
				# argument - DOCIT
				#
				# DOCIT
				def initialize( argument = nil )
					self.assign( argument )
				end
				# DOCIT
				def to_i( )
					# TODO implement this; assume unsigned encoding of binary values
				end
				# DOCIT
				def to_s( )
					# TODO implement this; assume unsigned encoding of binary values
				end
				# DOCIT
				def less_than?( rhs )
					if Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Memory_Location )
						return	self.to_i( ) < rhs.to_i( )
					elsif Asm::Boilerplate::true_if_type( argument ,Integer )
						return	self.to_i( ) < rhs
					else
						raise "wtf; stop it"
						# TODO reduce exception boilerplate
					end
				end
				# DOCIT
				def equal_to?( rhs )
					if Asm::Boilerplate::true_if_type( argument ,Asm::Virtual_Machine::Memory_Location )
						return	self.to_i( ).equal?( rhs.to_i( ) )
					elsif Asm::Boilerplate::true_if_type( argument ,Integer )
						return	self.to_i( ).equal?( rhs )
					else
						raise "wtf; stop it"
						# TODO reduce exception boilerplate
					end
				end
				# DOCIT
				def valid?
					return	Asm::BCPU::Memory::Index::valid?( self.to_i( ) )
				end
			end
			# DOCIT
			class Value < Asm::BCPU::Word
				# DOCIT
				def to_i( signed = true )
					# TODO implement this
				end
			end
			# DOCIT
			module Index
				# DOCIT
				def valid?( argument )
					return	(argument >= Asm::Literals_Are_Magic::Memory::inclusive_minimum_index) && (argument < Asm::Literals_Are_Magic::Memory::exclusive_maximum_index) 
				end
			end
		end
		# DOCIT
		module Register
			# DOCIT
			def location( register_literal )
				# TODO make an instance of Memory::Location based on /R[0-9]+/
			end
		end
	end
end