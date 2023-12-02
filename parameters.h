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
    LOAD,
    MOVE1,
    ADD,
    JUMP3,
    RESET4,
    IF0JUMP,
    IF1JUMP,
    LOADSWITCH,
    CALL8,
    RET,
    LOADREG10,
    INC,
    COPY12,
    LSHIFT,
    DECREMENT,
    RSHIFT } opCodes;


