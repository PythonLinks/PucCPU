`timescale 1ns/1ps
`include "cpu.sv"

module top();
`include "parameters.h"
reg clock;
wire reset;

wire [COUNTER_WIDTH -1:0]  count;
wire [INSTRUCTION_WIDTH -1:0]          instruction ;
wire [REGISTER_WIDTH-1 : 0]	   accumulator;
wire [REGISTER_WIDTH-1: 0]          register1;
wire [REGISTER_WIDTH-1: 0]          aluResult;      
   
CPU cpu (.clock(clock),
	 .reset(reset),
         .count(count),
         .instruction(instruction),
         .accumulator(accumulator),
         .register1(register1),
         .aluResult(aluResult));

	 
always #10 clock = ~clock; 


initial begin
    clock = 0;
    cpu.counter.count = 0 ;  
    $display ("COUNT   OPCODE     VALUE  ACCUMULTOR  REGISTER1, ALURESULT ");
    $monitor ( "  ", 
             count,"       ",
             instruction[11:8],"       ", 
             instruction [7:0],"       ",
            accumulator, "   ",
            register1, "          ", 
            aluResult);
    #200;
    $finish;
    $display("End of simulation");
end
   
endmodule // top


