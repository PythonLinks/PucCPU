`default_nettype none

`timescale 1ns/100ps
`include "../../PBL/Modules/global_parameters.vh"

module MEMORY (pc, instruction);
`include "../../PBL/Modules/parameters.sv"

    input [PC_WIDTH-1 : 0] pc;
    output reg [INSTRUCTION_WIDTH-1 : 0] instruction;
    `ifdef PBL   
       reg [INSTRUCTION_WIDTH - 1: 0] memory [0:255];
    `else
      reg [INSTRUCTION_WIDTH - 1: 0] memory [0:11];       
    `endif
   
    assign instruction = memory [pc];

    `define PBLSCRIPT   1
initial
    `ifdef PBLSCRIPT
      $readmemh("../../NEW/Simulation/hex.hex", memory);
    `else
      $readmemh("../../NEW/verilog/asm.hex", memory, 0, 11);
   `endif
endmodule  
