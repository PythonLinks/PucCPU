`include "cpu.sv"

module top();
`include "parameters.h"
reg clock;
wire reset;

wire [COUNTER_WIDTH -1:0] count;
wire [WIDTH -1:0]instruction ;
   
   
CPU cpu (.clock(clock),
	 .reset(reset),
         .count(count),
         .instruction(instruction));

	 
always #10 clock = ~clock; 


initial begin
    clock = 0;
    cpu.decoder.reset = 0;
    cpu.counter.count = 0 ;  
    $display ("CLOCK   COUNT   INSTRUCTION RESET");
    $monitor (clock,"         ", count,"       ",  instruction,"       ", cpu.decoder.reset);
    #120;
    $display("End of simulation");
    $finish;
end
   
endmodule // top


