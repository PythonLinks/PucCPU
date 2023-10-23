`include "counter.sv"
`include "memory.sv"
`include "decoder.sv"

module CPU(input clock,
	   output wire reset,
           output [COUNTER_WIDTH-1 : 0] count, 
           output [WIDTH-1 : 0]instruction);
    
    `include "parameters.h"
    COUNTER counter( .clock(clock),
		     .reset (reset),
		     .count (count));

    MEMORY memory ( .count(count),
		    .instruction (instruction));
  
        
    DECODER decoder (.clock(clock),
                     .reset(reset),
                     .instruction (instruction) );

endmodule   
