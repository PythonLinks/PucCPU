`timescale 1ns/1ps
`include "cpu.sv"

module top();
`include "parameters.h"
reg clock;
wire isReset;

wire [PC_WIDTH -1:0]  pc;
wire [INSTRUCTION_WIDTH -1:0]          instruction ;
wire [REGISTER_WIDTH-1 : 0]	   accumulator;
wire [REGISTER_WIDTH-1: 0]          registerValue;
wire [REGISTER_WIDTH-1: 0]          aluResult;      
   
CPU cpu (.clock(clock),
	 .isReset(isReset),
         .pc(pc),
         .instruction(instruction),
         .accumulator(accumulator),
         .registerValue(registerValue),
         .aluResult(aluResult));

	 
always #10 clock = ~clock; 


initial begin
    clock = 0;
    cpu.pc = 0 ;
    $display ("   PC  OPCODE InstValue  ACCUMULTOR  REGValue, ALURESULT ");
    $monitor ( "  ", 
             pc,"      %h    ",
             instruction [15:12], "   ", 
             instruction [3:0],"       ",
             accumulator, "       ",
             registerValue, "          ", 
             aluResult);
   
    #200;
    $finish;
    $display("End of simulation");
end
   
endmodule // top


