`default_nettype none


module MEMORY (pc, instruction);
   `include "parameters.h"
    input [PC_WIDTH-1 : 0] pc;
    output reg [INSTRUCTION_WIDTH-1 : 0] instruction;
    `ifdef PBL   
       reg [INSTRUCTION_WIDTH - 1: 0] memory [0:255];
    `else
      reg [INSTRUCTION_WIDTH - 1: 0] memory [0:11];       
    `endif
   
    assign instruction = memory [pc];

   
initial
    `ifdef PBL
      $readmemh("pbl.hex", memory);
    `else
      $readmemh("asm.hex", memory);
   `endif
endmodule  



 
