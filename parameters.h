parameter PC_WIDTH = 5;
parameter REGISTER_WIDTH = 8;
parameter NUMBER_OF_REGISTERS = 8;

//Instruction is 4 bits instructin, 4 bits register, 8 bits address 
parameter INSTRUCTION_WIDTH = 40; 
parameter OPCODE_WIDTH = 6;
parameter REGISTER_ID_WIDTH = 8;
parameter VALUE_WIDTH = 8;

parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;
parameter ZERO = 8'b0;

parameter UseRegister = 2'b0;
parameter useBit = 2'b01;
parameter useMemory = 2'b10;
parameter useImmediate = 2'b11;


`include "instructions.h"

`ifndef PBL
 `define PBL 8
`endif
