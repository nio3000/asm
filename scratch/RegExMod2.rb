#!/usr/bin/ruby
require re.c

input = ""

ARGV.each do |arg|
	input = input + " " + arg
end

unless ARGV.length > 0
	input = "#100=ASM"
	#abort("No instructions were entered in")
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
registry = "(r|R)[0-9]+"
decimal = "[d]{,1}[\+\-]{,1}[0-9]+"
binary = "(0)(b|B)[\+\-]{,1}[0-1]+" #Accepts other digits but doesn't capture
decimalUnsigned = "[0-9]+"

captureBOL = "(?<begin of line>^)" #^
captureEOL = "(?<end of line>$)" #$

captureKeyword0 = "(?<keyword>(MOVE)|(NOT))" #0 Corresponds
captureKeyword1 = "(?<keyword>((AND)|(OR)|(ADD)|(SUB)|(MOVEZ)|(MOVEX)|(MOVEP)|(MOVEN)))"
captureKeyword2 = "(?<keyword>(ADDI)|(SUBI))"
captureKeyword3 = "(?<keyword>(SET)|(SETH))"
captureKeyword4 = "(?<keyword>(INCIZ)|(DECIN))"

captureWhitespace = "(?<whitespace>[\s\t]*)"
captureWhitespaceReg = "(?<whitespace>[\s\t]+)"
captureRegLiteral = "(?<registry literal>" + registry +")"
captureLiteral = "(?<literal>(" + decimal + ")|(" + binary + "))"
captureDelimiter = "(?<delimiter>[,])"
captureComment = "(?<Comment>(//)*)" 

captureASM = "(?<ASM>(ASM))"
poundLiteral = "(?<literal>(#)(" + decimalUnsigned + "))" 
equalDelimiter = "(?<delimiter>[=])"

dev0 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
 + captureLiteral + captureWhitespace + captureComment
 
dev1 = captureBOL + captureWhitespace + poundLiteral + captureWhitespace + equalDelimiter + captureWhitespace \
 + captureASM + captureWhitespace + captureComment

format0 = captureBOL + captureWhitespace + captureKeyword0 + captureWhitespaceReg + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
 + captureComment #+ captureEOL
 
format1 = captureBOL + captureWhitespace + captureKeyword1 + captureWhitespaceReg + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
 + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace + captureComment
 
format2 = captureBOL + captureWhitespace + captureKeyword2 + captureWhitespaceReg + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace \
 + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment
 
format3 = captureBOL + captureWhitespace + captureKeyword3 + captureWhitespaceReg + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace + captureComment
 
format4 = captureBOL + captureWhitespace + captureKeyword4 + captureWhitespaceReg + captureRegLiteral \
 + captureWhitespace + captureDelimiter + captureWhitespace + captureLiteral + captureWhitespace \
 + captureDelimiter + captureWhitespace + captureRegLiteral + captureWhitespace + captureComment
 
formatComment = captureBOL + captureWhitespace + captureComment
formatWhite = captureBOL + captureWhitespace

#New Expressions
format0RegEx = Regexp.new(format0)
format1RegEx = Regexp.new(format1)
format2RegEx = Regexp.new(format2)
format3RegEx = Regexp.new(format3)
format4RegEx = Regexp.new(format4)

dev0RegEx = Regexp.new(dev0)
dev1RegEx = Regexp.new(dev1)

commentRegEx = Regexp.new(formatComment)
whiteRegEx = Regexp.new(formatWhite)

if format0RegEx.match(input)
puts("format 0")
end

if format1RegEx.match(input)
end

if format2RegEx.match(input)
end

if format3RegEx.match(input)
end

if format4RegEx.match(input)
end

if dev0RegEx.match(input)
puts("Dev 0")
end

if dev1RegEx.match(input)
puts("Dev 1")
end

if commentRegEx.match(input)
end

if whiteRegEx.match(input)
end