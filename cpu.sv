//`ifdef IVERILOG
`include "memory.sv"
`include "alu.sv"
//`endif
  
module CPU(clock,
	   isReset,
           pc, 
           instruction,
           accumulator,
           register1,
           aluResult);
    
   `include "parameters.h"
   input wire		  clock;
   output wire		  isReset;
   output reg [PC_WIDTH-1:0]     pc;
   output wire [INSTRUCTION_WIDTH-1:0] instruction;
   output reg  [REGISTER_WIDTH-1:0]  accumulator;
   output reg  [REGISTER_WIDTH-1:0]  register1;
   output wire [REGISTER_WIDTH -1:0] aluResult;
   wire	       [3:0]    opCode;
   assign opCode  = instruction[10:8];
   reg  [REGISTER_WIDTH-1:0]  value;      

  
always @ (posedge clock) 
   case (opCode)
     JUMP   : pc = instruction[3:0]; 
     RESET  : pc = 4'd0;
     default: pc = pc + 1'b1;  
  endcase
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));

   assign opCode = instruction[12:8];

   assign isReset = (opCode == RESET);

   
   assign value = instruction [REGISTER_WIDTH-1:0];
   ALU alu (.accumulator(accumulator),
            .register1 (register1),
            .opCode (opCode), 
            .aluResult(aluResult));


   always @(posedge clock) 
    if (opCode == MOVE) 
      register1 <= accumulator;
   
   always @(posedge clock)
     casex (opCode)
     ADD:      accumulator <= aluResult;
     LOADI:    accumulator[7:0] <= value[7:0];
     RESET:    accumulator <= 0;  
     default:  accumulator <= accumulator;
     endcase
endmodule   
