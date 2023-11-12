`define IVERILOG

`ifdef IVERILOG
`include "memory.sv"
`include "alu.sv"
`endif
  
module CPU(clock,
	   isReset,
           pc, 
           instruction,
           accumulator,
           registerValue,
           aluResult);
    
   `include "parameters.h"
   input wire		  clock;
   output wire		  isReset;
   
   output reg  [PC_WIDTH-1:0]          pc;
   output wire [INSTRUCTION_WIDTH-1:0] instruction;
   output reg  [REGISTER_WIDTH-1:0]    accumulator;
   reg         [REGISTER_WIDTH-1:0]    registers[7];
   wire [3:0] 			       selectedRegister;
   output wire [REGISTER_WIDTH-1:0]    registerValue;
   output wire [REGISTER_WIDTH -1:0]   aluResult;
   wire	       [3:0]    opCode;
   wire        [REGISTER_WIDTH-1:0]  instructionValue;
   
   assign opCode           = instruction [INSTRUCTION_WIDTH-1:
                                          INSTRUCTION_WIDTH -4];
   assign instructionValue = instruction [REGISTER_WIDTH-1:0];   
   assign selectedRegister = instruction [INSTRUCTION_WIDTH-5:
                                          INSTRUCTION_WIDTH -7];
   assign registerValue    = registers  [1];//] [selectedRegister] ;
   
  
always @ (posedge clock) 
   case (opCode)
     JUMP3   : pc = instructionValue[PC_WIDTH-1:0]; 
     RESET4  : pc = 4'd0;
     default: pc = pc + 1'b1;  
   endcase
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));

   assign isReset = (opCode == RESET4);
  
   ALU alu (.accumulator(accumulator),
            .registerValue (registerValue),
            .opCode (opCode), 
            .aluResult(aluResult));


   always @(posedge clock) 
    if (opCode == MOVE1) 
      registers[1] <= accumulator;
   
   always @(posedge clock)
     casex (opCode)
     ADD2:      accumulator <= aluResult;
     LOAD0:     accumulator <= instructionValue;
     RESET4:    accumulator <= 0;  
     default:   accumulator <= accumulator;
     endcase
endmodule   
