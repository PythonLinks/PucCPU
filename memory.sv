
module MEMORY ( count, instruction);
   `include "parameters.h"
    input [COUNTER_WIDTH-1 : 0] count;
    output reg [WIDTH-1 : 0] instruction;
   
always @(*)   
   case (count)
     4'b0011:   instruction = 'b111; 
     default:   instruction = 'b000;
   endcase
endmodule  


 
