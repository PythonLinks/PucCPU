
module MEMORY (pc, instruction);
   `include "parameters.h"
    input [PC_WIDTH-1 : 0] pc;
    output reg [INSTRUCTION_WIDTH-1 : 0] instruction;
   
always @(*)   
   case (pc)
     4'd1:    instruction = {LOADI, 3'd1, 8'b0000_0011};
     4'd2:    instruction = {MOVE,  3'd1, 8'd0};
     4'd3:    instruction = {LOADI, 3'd1, 8'b0000_0001}; 
     4'd4:    instruction = {ADD,   3'd1, 8'd0};
     4'd5:    instruction = {JUMP,  3'd1, 8'd4};
     4'd6:    instruction = {LOADI, 3'd1, 8'b0000_0001}; 
     4'd7:    instruction = {ADD,   3'd1, 8'd0};
     4'd8:    instruction = {RESET, 3'd1, 8'd0};      
     default: instruction = 0;
   endcase
endmodule  



 
