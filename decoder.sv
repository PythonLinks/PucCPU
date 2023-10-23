module DECODER (clock, reset, instruction);
   `include "parameters.h"
   input  clock;
   output reg reset;
   input [WIDTH-1:0] instruction;


always @(posedge clock)   
  case(instruction)
     3'b111:   reset = 1'b0;
     3'b000:   reset = 1'b1;
     default:  reset = 1'b1;
  endcase   
   
endmodule     
