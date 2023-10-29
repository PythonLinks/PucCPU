
module MEMORY ( count, instruction);
   `include "parameters.h"
    input [COUNTER_WIDTH-1 : 0] count;
    output reg [INSTRUCTION_WIDTH-1 : 0] instruction;
   
always @(*)   
   case (count)
     4'd1:   instruction = {LOADI, 8'b0000_0011};
     4'd2:   instruction = {MOVE,  8'd0};
     4'd3:   instruction = {LOADI, 8'b0000_0001}; 
     4'd4:   instruction = {ADD,   8'd0};
     4'd5:   instruction = {RESET, 8'd0};
     4'd6:   instruction = {LOADI, 8'b0000_0001}; 
     4'd7:   instruction = {ADD,   8'd0};
     4'd8:   instruction = {RESET, 8'd0};      
     default:   instruction = 11'b0;
   endcase
endmodule  


 
