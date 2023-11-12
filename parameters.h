parameter PC_WIDTH = 4;
parameter REGISTER_WIDTH = 8;

//Instruction is 4 bits instructin, 3 bits register, 8 bits address 
parameter INSTRUCTION_WIDTH = 16; 
parameter OPCODE_WIDTH = 4;
parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;


enum bit [3:0] {LOAD0,  MOVE1, ADD2, JUMP3, RESET4,  NOOP5,   OR6,  INCREMENT7, AND8} opCodes;


