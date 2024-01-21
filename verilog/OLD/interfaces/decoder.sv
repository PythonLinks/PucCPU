interface Decoder (clock,
	     reset,
	     source1,
	     source1_type,	   
             source2,
             source2_type,		   
             destination,
             destination_type		   
	     opCode,
             argument_value,		   
             pc,
 );
   
  `include "parameters.h"
  input clock;
  input reset;
  output wire [REGISTER_WIDTH-1 :0]	   source1;   
  output wire [1:0]			   source1_type;
   
  output wire [REGISTER_WIDTH-1 :0]	   source2;
  output wire [1:0]			   source2_type;
   
  output wire [REGISTER_WIDTH-1 :0]	   destination;
  output wire [1:0]			   destination_type;   
   
  output wire  [OPCODE_WIDTH - 1:0] 	   opCode;
  output wire [REGISTER_WIDTH-1 :0]	   argument_value;   
  ouput wire   [PC_WIDTH-1: 0]             pc;
 					   
endinterface
   
