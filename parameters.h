parameter PC_WIDTH = 5;
parameter REGISTER_WIDTH = 8;

//Instruction is 4 bits instructin, 4 bits register, 8 bits address 
parameter INSTRUCTION_WIDTH = 16; 
parameter OPCODE_WIDTH = 4;
parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;


enum bit [3:0] {LOAD0,  MOVE1, ADD2, JUMP3, RESET4,
    IF0JUMP5,
    IF1JUMP6,   LOADSWITCH7, CALL8, EXIT9, LOADREG10,
    INCREMENT11, COPY12,LSHIFT13} opCodes;


