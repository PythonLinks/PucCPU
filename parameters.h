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
    ADD=8,         //h08   
    RESET=18,      //h18
    IF1JUMP=19,    //h13
    CALL=21,       //h15
    RET=23,        //h17
    DECREMENT=25,  //h19
    LOAD=26,       //h1a
    LOADSWITCH=27, //h1b
    IF0JUMP=28,    //h1c
    INC=29,        //h1d
    LSHIFT=30,     //h1e
    RSHIFT=31      //h1f
    } opCodes;


