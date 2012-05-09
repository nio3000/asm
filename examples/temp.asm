// examples/temp.asm
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