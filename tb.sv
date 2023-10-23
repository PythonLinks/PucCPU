`timescale 1ns/1ps
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
    cpu.counter.count = 0 ;  
    $display ("COUNT   INSTRUCTION RESET PReV");
    $monitor ( count,"       ",  instruction,"       ", cpu.counter.reset);
    #120;
    $finish;
    $display("End of simulation");
end
   
endmodule // top


