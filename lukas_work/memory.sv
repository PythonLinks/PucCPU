`default_nettype none


module MEMORY (pc, instruction);
    `include "parameters.h"
    input [PC_WIDTH-1 : 0] pc;
    output reg [INSTRUCTION_WIDTH-1 : 0] instruction;
    reg [INSTRUCTION_WIDTH - 1: 0] memory [0:11];    
   
    assign instruction = memory [pc];

initial 
    $readmemh("asm.hex", memory);
   
endmodule  



 
