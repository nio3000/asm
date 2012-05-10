// # examples/syntax_errors.asm
// * this file should fail to execute in the BCPU VM.
// 	* statements that should fail should have a comment after them; // invalid
// 	* statements that should not fail should have a comment after them; // valid
# 15 = 666	// valid
# 666 = asm	// valid

// 'SET RD, data'
// 	data-argument range
SET R0 ,d255	// valid
SET R0 ,d0	// valid
SET R0 ,d256	// invalid	
SET R0 ,d-255	// invalid
SET R0 ,d-256	// invalid
SET R0 ,d-1	// invalid

// 'SETH RD, data'
// 	data-argument range
SETH R0 ,d255	// valid
SETH R0 ,d0	// valid
SETH R0 ,d256	// invalid	
SETH R0 ,d-255	// invalid
SETH R0 ,d-256	// invalid
SETH R0 ,d-1	// invalid

// 'ADDI RD, RA ,data'
// 	data-argument range
ADDI R0 ,R0 ,00000
ADDI R0 ,R0 ,000000000000000000000000000000000000000000000000000000000000000
ADDI R0 .R0 .00000
ADDI R0 ,R0 ,R9
ADDI R0 ,R15 ,1
ADDI R0 ,R16 ,1

//
SET R6 ,d5
MOVE R15 ,R6

MOVE R15 ,R15

SET R15 ,Ob1
SET R15 //
SET R15 ,000000000000
SET R15 ,00b0000000000
