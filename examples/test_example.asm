// examples/test_example.asm
//Sets Program Counter to 100
#15 = 100

//Load OpCode to memory location 100 
#100=asm

//R2 <- 5
#2=5
//R2 <- 0b111
#2=0b111

//R1 <-- R2, R2 = 5
Move R1,R2

//R1 <-- bitwise NOT R1, R1 = 5
NOT R3, R1

//R4 <-- R0 bitwise AND R2, R0 = 0, R2 = 5 or 0b101, R4 = 0 
AND R4, R0, R2

//R4 <-- R0 bitwise AND R2, R0 = 0, R2 = 5 or 0b101, R4 = 0b101
OR R4, R0, R2

//R6 <-- R4 + R5, R6 = 0b101
ADD R6,R4,R5

//R7 <-- R5 - R4, R7 = -5 or 1111 1111 1111 1011
SUB R7,R5,R4

//R8 = -5 + 3 = -2 or 1111 1111 1111 1110
ADDI R8, R5, 0b0010
//ADDI R8, R5, 4

//R9 = 0b10001
SUBI R9, R6, 12

//Check lower bound of R10
SET R10, 0b11110111

//Check upper bound of R10
SETH R10, 0b11101111

//R12 = -5 because R12 = 0 or it should be
INCIZ R12, 0b101, R12

//R13 = something
DECIN R13, 3, R12

//R14 = 5
MOVEZ R14, R1, R14

//R14 = 5 because R8 = -2
MOVEX R14, R2, R8

//R14 = 5 because R2 = 5
MoveP R14, R2, R2

//R14 = 0 because R8 = -2
Moven R14,R5,R8