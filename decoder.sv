`default_nettype none

module DECODER (clock, reset, instruction);
   `include "parameters.h"
   input  clock;
   output reg reset;
   input [INSTRUCTION_WIDTH-1:0] instruction;


always @(*)   
  case(instruction)
     3'b111:   reset = 1'b1;
     3'b000:   reset = 1'b0;
     default:  reset = 1'b0;
  endcase   
   
endmodule     
