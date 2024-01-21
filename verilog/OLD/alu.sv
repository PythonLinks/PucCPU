`default_nettype none
`timescale 1ns/1ps

module ALU(
           opCode, 
           register1Value,
           register2Value,
	   instructionValue,
	   switch,
           aluResult);
   `include "parameters.h"
   input  [OPCODE_WIDTH -1:0] opCode;
   input  [REGISTER_WIDTH -1:0] register1Value;   
   input  [REGISTER_WIDTH -1:0] register2Value; 
   input  [REGISTER_WIDTH -1:0] instructionValue;
   input			switch;
   output reg [REGISTER_WIDTH -1:0] aluResult;

always @ (*)   
   case (opCode)
     LOADSWITCH:   aluResult <= switch ? 8'b1: 8'b0;
     LOAD:         aluResult <= instructionValue;
     ADD:          aluResult <= register1Value + register2Value;
     LSHIFT:      aluResult <= {register1Value[6:0],register1Value[7]};
     RSHIFT:      aluResult <= {register1Value[0], register1Value[7:1]};
     INC:   aluResult <= register1Value + 1'b1;
     DECREMENT:   aluResult <= register1Value -  1'b1;     
     //AND:         aluResult <= register1Value && register2Value;
     //OR:          aluResult <= register1Value | register2Value;
     default:      aluResult <= 0;
   endcase // case (opCode)
   
endmodule
