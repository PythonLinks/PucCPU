//`define HISSTACK 1
`timescale 1ns/1ps
`ifdef HISSTACK
module HisStack (clock, call, return, reset, called_from, return_to);
`include "../../PBL/Modules/parameters.sv"
   input call;
   input return;
   input reset;
`else 
module MyStack(clock, reset_code, called_from, return_to);
`include "../../PBL/Modulesparameters.sv"
   
   input [OPCODE_WIDTH - 1:0] reset_code;
  `endif // !`ifdef HISSTACK
   input		      clock;
   input [PC_WIDTH-1:0] called_from;
   output reg [PC_WIDTH-1:0] return_to;   
   reg  [PC_WIDTH-1:0]	       returnStack[16];
   reg  [3:0]		       stackOffset;
   reg  [3:0]	               previousStackOffset;  

//We do not want a negative stack offset   
assign previousStackOffset = stackOffset ? (stackOffset -1) : 0;
assign return_to =   returnStack [previousStackOffset];


`ifdef HISSTACK 
//BIT INSTRUCTION VERSION  
always @(posedge clock)
  if (reset_code == CALL)begin
    returnStack [stackOffset] <= called_from + 1;
  end
   
always @ (posedge clock)    
  case ({call,return,reset})
    3b'100:   stackOffset <= stackOffset - 1'b1;
    3b'010:   stackOffset <= stackOffset + 1'b1;
    3b'001:  stackOffset <= 0;
    default: stackOffset <= stackOffset; 
  endcase // case (reset_code)
`else // !`ifdef HISSTACK

//OPCODE VERSION
always @ (posedge clock) 
  case (reset_code)
    RET:   stackOffset <= stackOffset - 1'b1;
    CALL:   stackOffset <= stackOffset + 1'b1;
    RESET:  stackOffset <= 0;
    default: stackOffset <= stackOffset; 
  endcase          
   
always @(posedge clock)
  if (reset_code == CALL)
    returnStack [stackOffset] <= called_from + 1;

`endif // !`ifdef HISSTACK
   
initial
  begin
  stackOffset = 0;
  end

 endmodule  
