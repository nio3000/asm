#!/usr/bin/ruby
# regexmod v0.1 (Regular Expression Module)
# The script takes a single instruction and converts it to binary.
#
# The script takes a command and registers as input
# Example:
#   $ irb RegExMod.rb MOVE R1,R2
#
# Note: This script is not white space friendly so make sure 
# register values contain no white spaces. The program will not 
# function properly if you enter in MOVE R1, R2. Also all 
# commands must be capatilize.

require re.c

input = ""

ARGV.each do |arg|
	input = input + " " + arg
end

unless ARGV.length > 0
	abort("No instructions were entered in")
end

#Regular Expressions
#Commands
move = "MOVE" #R[0-9][0-9],R[0-9][0-9]/
notComm = "NOT"
andComm = "AND"
ORComm = "OR"

add = "ADD"
sub = "SUB"
addi = "ADDI"
subi = "SUBI"

set = "SET"
seth = "SETH"
inciz = "INCIZ"
decin = "DECIN"

movez = "MOVEZ"
movex = "MOVEX"
movep = "MOVEP"
moven = "MOVEN"

#Literals
registry = "R[0-9]+"
decimal = "[dB]{,1}[0-9]+"
binary = "0[bB][\+\-]{,1}[01]+"

captureBOL = "(<?begin of line>^)"
captureEOL = "(<?end of line>$)" 

captureKeyword0 = "(<?keyword>MOVE|NOT)" #0 Corresponds 

captureWhitespace = "(<?whitespace>[\s\t]*)"
captureRegLiteral = "(<?registry literal>" + registry +")"
captureLiteral = "(<?literal>(" + decimal + ")|(" + binary + "))"
captureDelimiter = "(<?delimiter>,)"
captureComment = "(<?Comment>//)" 

format0 = captureBOL + captureWhitespace + captureKeyword0 + captureWhitespace + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace + captureComment
 
#format1 =
string1 = /[A-Za-z0-9]+,[A-Za-z0-9]+/
string2 = /[A-Za-z0-9]+,[A-Za-z0-9]+,[A-Za-z0-9]+/

#New Expressions
format0RegEx = regexp.new(format0)

format0RegEx.match(input)

# OpCode = ""
# format = 0
# 
# if input.match move
# 	if input.match movez
# 		OpCode += "1100"
# 		format = 1
# 	elsif input.match movex
# 		OpCode += "1101"
# 		format = 1
# 	elsif input.match movep
# 		OpCode += "1110"
# 		format = 1
# 	elsif input.match moven
# 		OpCode += "1111"
# 		format = 1
# 	else
# 		OpCode += "0000"
# 		format = 0
# 	end
# elsif input.match notComm
# 	OpCode += "0001"
# 	format = 0
# elsif input.match andComm
# 	OpCode += "0010"
# 	format = 1
# elsif input.match ORComm
# 	OpCode += "0011"
# 	format = 1
# 
# elsif input.match add
# 	if input.match addi
# 		OpCode += "0110"
# 		format = 2
# 	else
# 		OpCode += "0100"
# 		format = 1
# 	end
# elsif input.match sub
# 	if input.match subi
# 		OpCode += "0111"
# 		format = 2
# 	else
# 		OpCode += "0101"
# 		format = 1
# 	end
# 
# elsif input.match set
# 	if input.match seth
# 		OpCode += "1001"
# 		format = 3
# 	else
# 		OpCode += "1000"
# 		format = 3
# 	end
# 	
# elsif input.match inciz
# 	OpCode += "1010"
# 	format = 4
# elsif input.match decin
# 	OpCode += "1011"
# 	format = 4
# else
# 	abort("Invalid Command")
# end
# 
# puts(OpCode)
# values = Array.new(3)
# if ARGV[1].match string1 or ARGV[1].match string2
# 	values = ARGV[1].split(",")
# else
# 	abort("Syntax Error: " + ARGV[1])
# end
# 
# case format
# when 0
# 	if values.length != 2
# 		abort("Syntax Error, Command only uses 2 registry values")
# 	end
# 	
# 	values.each do |value|
# 		if value.match registry
# 			theNumber = Integer(value.gsub("R", ""))
# 			if theNumber < 16
# 				binConvert = theNumber.to_s(2)
# 				while (binConvert.length != 4)
# 					binConvert = "0" + binConvert
# 				end
# 				OpCode += binConvert + "0000"
# 			else
# 				abort("Registry Number: " + value + " is too high")
# 			end
# 		else
# 			abort(value + " is not a proper registry value")
# 		end
# 	end
# when 1
# 	if values.length != 3
# 		abort("Syntax Error, Command only uses 3 registry values")
# 	end
# 	
# 	values.each do |value|
# 		if value.match registry
# 			theNumber = Integer(value.gsub("R", ""))
# 			if theNumber < 16
# 				binConvert = theNumber.to_s(2)
# 				while (binConvert.length != 4)
# 					binConvert = "0" + binConvert
# 				end
# 				OpCode += binConvert
# 			else
# 				abort("Registry Number: " + value + " is too high")
# 			end
# 		else
# 			abort(value + " is not a proper registry value")
# 		end
# 	end
# when 2
# 	if values.length != 3
# 		abort("Syntax Error, Command only uses 2 registry values and a 4-bit value")
# 	end
# 	
# 	for i in 0..1
# 		if values[i].match registry
# 			theNumber = Integer(values[i].gsub("R", ""))
# 			if theNumber < 16
# 				binConvert = theNumber.to_s(2)
# 				while (binConvert.length != 4)
# 					binConvert = "0" + binConvert
# 				end
# 				OpCode += binConvert
# 			else
# 				abort("Registry Number: " + values[i] + " is too high")
# 			end
# 		else
# 			abort(values[i] + " is not a proper registry value")
# 		end
# 	end
# 	
# 	if values[2].match integer
# 		if values[2].match binary
# 			binString = values[2].gsub("0b", "")
# 			if (binString.to_i(2) > 15)
# 				abort(values[2] + " is not a valid binary number")
# 			end
# 			while (binString.length != 4)
# 				binString = "0" + binString
# 			end
# 			OpCode += binString
# 		else
# 			data = Integer(integer)
# 			if data < 16
# 				binConvert = data.to_s(2)
# 				while binConvert.length != 4
# 					binConvert = "0" + binConvert
# 				end
# 			else
# 				abort("Integer value " + values[2] + " is to large")
# 			end
# 		end
# 	end
# when 3
# 	puts("format 3")
# when 4
# 	puts("format 4")
# end
# 
# puts(OpCode + " - " + OpCode.length.to_s(10))
