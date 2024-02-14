`timescale 1ns/100ps
`default_nettype none
module Parser (instruction,
		opCode,
		address1In,
		address2In,
		addressOut,
		address1Type,
		address2Type,
		outType,
		register1In,
		register2In,
		registerOut,
	        registerHasAddress,
		instructionValue);
   
`include "../../PBL/Modules/parameters.sv"

   input wire        [INSTRUCTION_WIDTH-1:0] instruction;
   output wire [OPCODE_WIDTH-1:0]             opCode;
   output wire [7:0]			       address1In;
   output wire [7:0]			       address2In;
   output wire [7:0]			       addressOut;   

   output wire [1:0]			       address1Type;
   output wire [1:0]			       address2Type;
   output wire [1:0]			       outType;   

   output wire        [   LOG_OF_REGISTERS-1:0]		       register1In;
   output wire        [   LOG_OF_REGISTERS-1:0]		       register2In;
   output wire        [   LOG_OF_REGISTERS-1:0]		       registerOut;
   output wire        [   LOG_OF_REGISTERS-1:0]		       registerHasAddress;      

   output wire [VALUE_WIDTH - 1 :0]   instructionValue;

   //NOW BEGIN THE ASSIGNMENTS
   assign registerHasAddress = { instruction [INSTRUCTION_WIDTH-1],
			         instruction [7],
			         instruction [6]
				 };
      
   assign opCode  = instruction [INSTRUCTION_WIDTH - 3:
                                       INSTRUCTION_WIDTH -8];
  
   assign address1In = instruction[INSTRUCTION_WIDTH-9:
                                          INSTRUCTION_WIDTH -16];

   assign address2In = instruction[INSTRUCTION_WIDTH-17:
                                          INSTRUCTION_WIDTH -24];
   assign addressOut = instruction[INSTRUCTION_WIDTH-25:
                                          INSTRUCTION_WIDTH - 32];
   
   assign instructionValue = instruction[INSTRUCTION_WIDTH-17:
                                          INSTRUCTION_WIDTH - 24];

   assign address1Type = instruction[5:4];
   assign address2Type = instruction[3:2];
   assign outType = instruction[1:0];
			 
   
   assign register1In = address1In[3:0];
   assign register2In = address2In[3:0];
   assign registerOut = addressOut[3:0];   

endmodule   
