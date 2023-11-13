`define IVERILOG

`ifdef IVERILOG
//`include "memory.sv"
//`include "alu.sv"
`endif
  
module CPU(clock,
	   isReset,
	   switch,
	   pc,
	   register1Value,
);
    
   `include "parameters.h"
   input wire		  clock;
   input  wire		  isReset;
   input wire				    switch;
   output wire  [REGISTER_WIDTH-1:0]   register1Value;
   
   wire  [REGISTER_WIDTH-1:0]   register0Value;   
   output reg  [PC_WIDTH-1:0]          pc;
   wire [INSTRUCTION_WIDTH-1:0] instruction;
   reg  [REGISTER_WIDTH-1:0]    accumulator;
   wire [REGISTER_WIDTH -1:0]   aluResult;
   wire [2:0]		       register0;
   wire [2:0]		       register1;   


   reg [REGISTER_WIDTH-1:0]    registers[7:0];
   reg [PC_WIDTH-1:0]	       returnStack[16];
   reg [3:0]		       stackOffset;
   wire	       [3:0]    opCode;
   wire        [REGISTER_WIDTH-1:0]    instructionValue;
   wire [PC_WIDTH - 1 : 0] 	       pcValue;
   wire [PC_WIDTH - 1 : 0] 	       returnV;

   
   //NOW BEGIN THE ASSIGNMENTS
   assign pcValue = instruction [PC_WIDTH-1:0];
   assign opCode       = instruction [INSTRUCTION_WIDTH-1:
                                          INSTRUCTION_WIDTH -4];
   assign instructionValue = instruction [REGISTER_WIDTH-1:0];   
   assign register0 = instruction[10:8];
   assign register1 = instruction[6:4];   
   assign register0Value = registers[0];
   assign register1Value = registers[1];
   wire  [OPCODE_WIDTH - 1:0] 	 resetCode;
   
   assign resetCode = isReset ? RESET4 : opCode; 
   
//Update the stacks
always @ (posedge clock) 
  case (resetCode)
    EXIT9:   stackOffset <= stackOffset - 1'b1;
    CALL8:   stackOffset <= stackOffset + 1'b1;
    RESET4:  stackOffset <= 0;
    default: stackOffset <= stackOffset; 
  endcase          

initial 
  stackOffset <=0;
         
always @(posedge clock)
  if (opCode == CALL8)
    returnStack [stackOffset] <= pc;
  else
    returnStack [stackOffset] <= returnStack [stackOffset] ;
    
assign returnV =   returnStack [0];
   
   
//Update the program counter   
always @ (posedge clock) 
   case (resetCode)
     EXIT9:         pc <= returnStack[stackOffset - 1'b1];
     CALL8:         pc <= instructionValue[PC_WIDTH-1:0];
     IF0JUMP5:    if (accumulator == 0) 
                      pc <= pcValue;
                   else
                      pc <= pc + 1'b1;  
     IF1JUMP6: if (accumulator != 0) 
                      pc <= pcValue;
                       else
                     pc <= pc + 1'b1;       
     JUMP3   : pc <= instructionValue[PC_WIDTH-1:0]; 
     RESET4  : pc <= 4'd0;
     default:  pc <= pc + 1'b1;  
   endcase
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));

  
   ALU alu (.accumulator(accumulator),
            .register0Value (register0Value),
            .register1Value (register1Value),	    
            .opCode (opCode), 
            .aluResult(aluResult));
   
   always @(posedge clock)
               if ((3'b000 == register0)&&(opCode == MOVE1))
                  registers[0] <= accumulator;
               else if ((3'b000 == register1)&&(opCode == COPY12))
                  registers[0] <= registers[register0];
               else
                  registers[0] <= registers[0];		 
   always @(posedge clock)
               if ((3'b001 == register0)&&(opCode == MOVE1))
                  registers[1] <= accumulator;
               else if ((3'b001 == register1)&&(opCode == COPY12))
                  registers[1] <= registers[register0];
               else
                  registers[1] <= registers[1];		 




	      
   always @(posedge clock)
     casex (opCode)
     LOADSWITCH7:  accumulator <= {15'b0,switch};
     ADD2:         accumulator <= aluResult;
     LOAD0:        accumulator <= instructionValue;
     LOADREG10:    accumulator <= registers[register0];
     INCREMENT11:  accumulator <= accumulator + 1'b1;
     RESET4:       accumulator <= 0;  
     default:      accumulator <= accumulator;
     endcase


initial
  
  $monitor(  "%h",
             opCode, "   ", 
             pc,"  %h",
             instructionValue, "  ",
//	     pcValue,"  ",
             accumulator, "     ",
	     register0, "     ",
	     register1, "     ", 	      
             register0Value, "     ",
             register1Value, "  ---->",//"     \n",
	     returnStack[0],  "   ",
	     returnStack [1], "   ",
             stackOffset	     
	     //"---------------------------------------------------" 
             //aluResult
);


//   $monitor (register1Value);
 

endmodule      

