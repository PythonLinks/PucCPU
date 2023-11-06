parameter PC_WIDTH = 4;
parameter REGISTER_WIDTH = 8;

//Instruction is 4 bits instructin, 3 bits register, 8 bits address 
parameter INSTRUCTION_WIDTH = 15; 
parameter OPCODE_WIDTH = 4;
parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;

enum bit [3:0] {INCREMENT, ADD,  MOVE, OR,  NOOP, LOADI,  RESET, JUMP , AND } opCodes;
//enum bit [3:0] {INCREMENT, ADD,  MOVE, OR,  NOOP, LOADI,  RESET, AND , JUMP} opCodes;

