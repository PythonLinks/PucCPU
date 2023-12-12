`default_nettype none

`define IVERILOG

`ifdef IVERILOG
`include "memory.sv"
`include "alu.sv"
`include "pc.sv"
`endif
  
module CPU(clock,
	   isReset,
	   switch,
	   pc,
	   register1Value,
);

`include "parameters.h"
   
   input  wire		               clock;
   input  wire		               isReset;
   input  wire			       switch;
   output wire  [PC_WIDTH-1:0]                pc;   
   output wire  [REGISTER_WIDTH-1:0]   register1Value;
   
   wire [OPCODE_WIDTH-1:0]             opCode;
   wire  [REGISTER_WIDTH-1:0]          register2Value;
   wire        [INSTRUCTION_WIDTH-1:0] instruction;
   wire        [REGISTER_WIDTH -1:0]   aluResult;
   wire [7:0]			       address1In;
   wire [7:0]			       address2In;
   wire [7:0]			       addressOut;   
   
   wire        [2:0]		       register1In;
   wire        [2:0]		       register2In;
   wire        [2:0]		       registerOut;   

   reg  [REGISTER_WIDTH-1:0]   registers[NUMBER_OF_REGISTERS-1:0];

   wire [VALUE_WIDTH - 1 :0]   instructionValue;


   //assign registers [0] = 0;

  //Since we can get a reset instruction
  //Or a reset by pushbutton, we have to update the instruction.  
  wire  [OPCODE_WIDTH - 1:0] 	 resetCode;   
  assign resetCode = isReset ? RESET : opCode; 
   
   //NOW BEGIN THE ASSIGNMENTS

   assign opCode       = instruction [INSTRUCTION_WIDTH-4:
                                          INSTRUCTION_WIDTH -8];
   assign address1In = instruction[INSTRUCTION_WIDTH-9:
                                          INSTRUCTION_WIDTH -16];

   assign address2In = instruction[INSTRUCTION_WIDTH-17:
                                          INSTRUCTION_WIDTH -24];
   assign addressOut = instruction[INSTRUCTION_WIDTH-25:
                                          INSTRUCTION_WIDTH - 32];
   
   assign instructionValue = instruction[INSTRUCTION_WIDTH-17:
                                          INSTRUCTION_WIDTH - 24];

   assign register1In = address1In[2:0];
   assign register2In = address2In[2:0];
   assign registerOut = addressOut[2:0];   
   
   assign register1Value = registers[1];
   assign register2Value = registers[2];   
   
   PC pcModule (.clock(clock),
		.resetCode (resetCode),
		.instructionValue(instructionValue),
		.registerValue(register2Value),
		.pc (pc));
   
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));
  
   ALU alu (
            .opCode (opCode), 
            .register1Value (register1Value),
            .register2Value (register2Value),
	    .instructionValue (instructionValue),
	    .switch (switch),
            .aluResult(aluResult));


   reg					 isALU;
   assign isALU = ((opCode == ADD) |
                   (opCode == LSHIFT ) | 
                   (opCode == RSHIFT) | 
                   (opCode == INC) | 
                   (opCode == LOAD) | 
                   (opCode == LOADSWITCH) | 
                   (opCode == DECREMENT) )
                   ;
	      
always @(posedge clock)
  case ({registerOut,isALU })
    {3'd1,TRUE}: begin
         registers[1] <= aluResult;
         registers[2] <= registers[2];
         end
       
    {3'd2,TRUE}: begin
         registers[1] <= registers[1];
         registers[2] <= aluResult;       
         end

    default:
         begin
         registers[1] <= registers[1];
         registers[2] <= registers[2];
         end
    endcase
       
 
//always @(posedge clock)
//     for (ii = 1 ; ii < NUMBER_OF_REGISTERS ; ii = ii+1) begin
//       if (ii == registerOut)
//           registers [ii] <= aluResult;
//       else
//           registers[ii] <= registers[ii];		
//     end 

initial 
  $display ("SW OP  PC Val R1 R2 RO Val1 Val2 ALU RG1 RG2 SOFFSET isALU  ");
   
initial  
  $monitor(
             switch, " %h",
             opCode, "   ", 
             pc,"  %h",
             instructionValue, " %h",
	     register1In, "  %h",
	     register2In, "  %h",
	     aluResult, " ",
	     registerOut, "  ",
             register1Value, "  ",
             register2Value, "  ",	   
             register1Value, " ",
	     register2Value, " ",
	     isALU
	     
);

//THIS ONE IS FOR TESTING THE REGISTER VALUES BEING SET
/*
initial 
  $display ("PC   OP R1 R2 RO   isALU VAL  ALU         Reg1      Reg2");
   
initial
   $monitor( pc, " ", 
             opCode, "   %h", 
	     register1In, " %h",
	     register2In, " %h",
	     registerOut, "       ",
	     isALU, " " ,
	     instructionValue, " ",
             aluResult, " ",
	     registers [1], " ",
	     registers [2]
             );
*/   
endmodule      

