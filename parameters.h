parameter PC_WIDTH = 5;
parameter REGISTER_WIDTH = 8;
parameter NUMBER_OF_REGISTERS = 8;

//Instruction is 4 bits instructin, 4 bits register, 8 bits address 
parameter INSTRUCTION_WIDTH = 32; 
parameter OPCODE_WIDTH = 8;
parameter REGISTER_ID_WIDTH = 8;
parameter VALUE_WIDTH = 8;

parameter TRUE   = 1'b1;
parameter FALSE  = 1'b0;


enum bit [OPCODE_WIDTH-1:0] {
    LOAD0,
    MOVE1,
    ADD2,
    JUMP3,
    RESET4,
    IF0JUMP5,
    IF1JUMP6,
    LOADSWITCH7,
    CALL8,
    EXIT9,
    LOADREG10,
    INCREMENT11,
    COPY12,
    LSHIFT13,
    DECREMENT14,
    RSHIFT15 } opCodes;


