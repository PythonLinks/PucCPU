`timescale 1ns/1ps
`ifdef IVERILOG
`include "cpu.sv"
`endif

module Top(clock,
           accumulator 
           );

   
`include "parameters.h"
input  clock;
wire reset;
output wire [REGISTER_WIDTH-1 : 0]	   accumulator;
   

wire [PC_WIDTH -1:0]  pc;
wire [INSTRUCTION_WIDTH -1:0]          instruction ;
wire [REGISTER_WIDTH-1: 0]          register1;
wire [REGISTER_WIDTH-1: 0]          aluResult;      
   
CPU cpu (.clock(clock),
	 .reset(reset),
         .pc(pc),
         .instruction(instruction),
         .accumulator(accumulator),
         .register1(register1),
         .aluResult(aluResult));

endmodule // top


