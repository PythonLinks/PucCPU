`include "counter.sv"
`include "memory.sv"
`include "alu.sv"

module CPU(clock,
	   reset,
           count, 
           instruction,
           accumulator,
           register1,
           aluResult);
    
   `include "parameters.h"
   input wire		  clock;
   output wire		  reset;
   output wire [COUNTER_WIDTH-1:0]     count;
   output wire [INSTRUCTION_WIDTH-1:0] instruction;
   output reg  [REGISTER_WIDTH-1:0]  accumulator;
   output reg  [REGISTER_WIDTH-1:0]  register1;
   output wire [REGISTER_WIDTH -1:0] aluResult;
   wire	       [OPCODE_WIDTH-1:0]    opCode;
   assign opCode  = instruction[10:8];
   reg  [REGISTER_WIDTH-1:0]  value;      

   
   COUNTER counter( .clock(clock),
		    .reset (reset),
		    .count (count));

   MEMORY memory ( .count(count),
		   .instruction (instruction));

   assign opCode = instruction[10:8];
   assign value = instruction [REGISTER_WIDTH-1:0];
   ALU alu (.accumulator(accumulator),
            .register1 (register1),
            .opCode (opCode), 
            .aluResult(aluResult));

   //wire			      clockEnable;
   //wire			      isLoadI; 

   //assign clockEnable = TRUE;  //!((opCode == MOVE)|| (opCode == NOOP));

   //assign reset = (opCode == RESET)? TRUE: FALSE;

   //assign isALU = (clockEnable && !reset)? FALSE:TRUE;
   //assign isLoadI = (opCode == LOADI);

   always @(posedge clock) 
    if (opCode == MOVE) 
      register1 <= accumulator;
   
   always @(posedge clock)
     casex (opCode)
     ADD:      accumulator <= aluResult;
     MOVE:     accumulator <= accumulator;       
     LOADI:    accumulator[7:0] <= value[7:0];
     RESET:    accumulator <= 0;  
     default:  accumulator <= accumulator;
     endcase
endmodule   
