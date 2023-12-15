interface Stack (clock,
	     reset,
	     opCode,
	     jumpAddress, 
             returnAddress)
  `include "parameters.h"
  input clock;
  input reset;
  input wire  [OPCODE_WIDTH - 1:0] 	 opCode;
  input wire [ADDRESS_WIDTH - 1 :0]        jumpAddress;
  input wire [ADDRESS_WIDTH - 1 :0]        returnAddress;   

endinterface
   
