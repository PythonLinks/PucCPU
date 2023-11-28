`default_nettype none

`define IVERILOG

`ifdef IVERILOG
`include "memory.sv"
`include "alu.sv"
`endif
  
module CPU(clock,
	   isReset,
	   switch,
	   pc,
	   register1Value,
	   opCode
);

`include "parameters.h"
   
   input  wire		               clock;
   input  wire		               isReset;
   input  wire			       switch;
   output wire  [REGISTER_WIDTH-1:0]   register1Value;   
   output wire	[OPCODE_WIDTH -1 :0]   opCode;

   wire  [REGISTER_WIDTH-1:0]          register2Value;
   output reg  [PC_WIDTH-1:0]          pc;
   wire        [INSTRUCTION_WIDTH-1:0] instruction;
   wire        [REGISTER_WIDTH -1:0]   aluResult;
   wire        [3:0]		       register1;
   wire        [3:0]		       register2;
   wire        [3:0]		       registerOut;   

   reg  [REGISTER_WIDTH-1:0]   registers[NUMBER_OF_REGISTERS-1:0];
   reg  [PC_WIDTH-1:0]	       returnStack[16];
   reg  [3:0]		       stackOffset;
   reg  [3:0]	               previousStackOffset;
   wire [VALUE_WIDTH - 1 :0]   instructionValue;
   wire [PC_WIDTH - 1 : 0]     pcPlusOne;   
   wire [PC_WIDTH - 1 : 0]     returnV;

   //NOW BEGIN THE ASSIGNMENTS
   assign pcPlusOne    = pc + 1;  
   assign opCode       = instruction [INSTRUCTION_WIDTH-1:
                                          INSTRUCTION_WIDTH -8];
   assign register1 = instruction[INSTRUCTION_WIDTH-9:
                                          INSTRUCTION_WIDTH -12];
   assign register2 = instruction[INSTRUCTION_WIDTH-13:
                                          INSTRUCTION_WIDTH -16];
   assign registerOut = instruction[INSTRUCTION_WIDTH-17:
                                          INSTRUCTION_WIDTH -20];
   assign instructionValue = instruction[7:0];
// [REGISTER_WIDTH-24:0];

   assign register2Value = registers[2];   
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
  stackOffset <= 0;
         
always @(posedge clock)
  if (opCode == CALL8)
    returnStack [stackOffset] <= pc + 1;
  else
    returnStack [stackOffset] <= returnStack [stackOffset] ;

assign previousStackOffset = stackOffset ? (stackOffset -1) : 0;
    
assign returnV =   returnStack [previousStackOffset];
   
//Update the program counter   
always @ (posedge clock) 
   case (resetCode)
     EXIT9:         pc <= returnStack[stackOffset - 1'b1];
     CALL8:         pc <= instructionValue[PC_WIDTH-1:0];
     IF0JUMP5:    if (registers[2] == 0) 
                      pc <= instructionValue;
                   else
                      pc <= pc + 1'b1;  
     IF1JUMP6: if (registers[2] != 0) 
                      pc <= instructionValue;
                      else
                      pc <= pc + 1;       
     JUMP3   : pc <= instructionValue[PC_WIDTH-1:0]; 
     RESET4  : pc <= 4'd0;
     default:  pc <= pc + 1'b1;  
   endcase
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));
  
   ALU alu (
            .register1Value (register1Value),
            .register2Value (register2Value),
            .opCode (opCode), 
            .aluResult(aluResult));


   reg					 isALU;
   assign isALU = ((opCode == ADD2) |
                   (opCode == LSHIFT13 ) | 
                   (opCode == RSHIFT15) | 
                   (opCode == INCREMENT11) | 
                   (opCode == DECREMENT14) ) ;

   int 	 			 ii;

always @(posedge clock)
  if ((4'd1 == registerOut)&& isALU)
     registers[1] <= aluResult; 
  else if ((4'd1 == registerOut)&&(opCode == LOAD0))
            registers[1] <= instructionValue;
  else
          registers[1] <= registers[1];

always @(posedge clock)
  if (4'd2 == registerOut)
    begin 
    if (isALU)
       registers[2] <= aluResult; 
    else if  (opCode == LOAD0)
              registers[2] <= instructionValue;
    else if  (opCode == LOADSWITCH7)
             registers[2] <= switch;
    end
   


 
//always @(posedge clock)
//     for (ii = 1 ; ii < NUMBER_OF_REGISTERS ; ii = ii+1) begin
//       if (ii == registerOut)
//           registers [ii] <= aluResult;
//       else
//           registers[ii] <= registers[ii];		
//     end 

initial 
  $display ("SW OP  PC Val R1 R2 RO     Value1           Value2 RS0 RS1 SOFFSET isALU  ");
   
initial  
  $monitor(
             switch, " %h",
             opCode, "   ", 
             pc,"  %h",
             instructionValue, " %h",
	     register1, "  %h",
	     register2, "  %h",
	     registerOut, " ",
//	     pcValue,"  ",
             register1Value, "     ",
             register2Value, "     ",	   
             //register1Value, "  ---->",//"     \n",
	     returnStack[0],  "   ",
	     returnStack [1], "   ",
             stackOffset, "     ",
	     isALU
	     
);

//THIS ONE IS FOR TESTING THE REGISTER VALUES BEING SET
/*
initial 
  $display ("PC   OP R1 R2 RO   isALU VAL  ALU         Reg1      Reg2");
   
initial
   $monitor( pc, " ", 
             opCode, "   %h", 
	     register1, " %h",
	     register2, " %h",
	     registerOut, "       ",
	     isALU, " " ,
	     instructionValue, " ",
             aluResult, " ",
	     registers [1], " ",
	     registers [2]
             );
*/   
endmodule      

