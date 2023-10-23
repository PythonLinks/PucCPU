module COUNTER (clock,                 
                reset,
                count);
   `include "parameters.h"   
   input clock;
   input reset;
   output reg [COUNTER_WIDTH-1:0] count;    
   
always @ (posedge clock) begin
    if (reset)  
      count <= 0;  
    else  
      count <= count + 1;  
  end  
endmodule 
