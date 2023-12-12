`default_nettype none

//ResetCode is the instructoin opcode, or the reset code if
//  reset is pushed.
module PC (clock,
	   resetCode,
	   instructionValue,
	   registerValue,
	   pc);
   
  `include "parameters.h"

  //First we have the program counter arguments, input and state.
  input clock;
  input wire  [OPCODE_WIDTH - 1:0] 	 resetCode;
  input wire [VALUE_WIDTH - 1 :0]        instructionValue;
  input wire  [REGISTER_WIDTH-1:0]          registerValue;   
  output reg  [PC_WIDTH-1:0]             pc;
  wire [PC_WIDTH - 1 : 0]                pcPlusOne;
  
  //NEXT we have the arguments for managing the stack 
  reg  [PC_WIDTH-1:0]	       returnStack[16];
  reg  [3:0]		       stackOffset;
  reg  [3:0]	               previousStackOffset;  
  wire [PC_WIDTH - 1 : 0]     returnV;

//Update the stacks
always @ (posedge clock) 
  case (resetCode)
    RET:   stackOffset <= stackOffset - 1'b1;
    CALL:   stackOffset <= stackOffset + 1'b1;
    RESET:  stackOffset <= 0;
    default: stackOffset <= stackOffset; 
  endcase          

initial
  begin
  stackOffset = 0;
  pc = 0;
  end
//We do not want a negative stack offset   
assign previousStackOffset = stackOffset ? (stackOffset -1) : 0;

//On a return we go to the previous stack offset not this one.     
assign returnV =   returnStack [previousStackOffset];
   
//No need to update the return stack on a return, as the value
//gets overwritten in the future.           
always @(posedge clock)
  if (resetCode == CALL)
    returnStack [stackOffset] <= pc + 1;
  else  //Not really needed
    returnStack [stackOffset] <= returnStack [stackOffset] ;
   
 assign pcPlusOne    = pc + 1;  
   
//Update the program counter   
always @ (posedge clock) 
   case (resetCode)
     RET:         pc <= returnStack[stackOffset - 1'b1];
     CALL:         pc <= instructionValue[PC_WIDTH-1:0];
     IF0JUMP:    if (registerValue == 0) 
                      pc <= instructionValue;
                   else
                      pc <= pc + 1'b1;  
     IF1JUMP:    if (registerValue != 0) 
                      pc <= instructionValue;
                      else
                      pc <= pc + 1;       
     RESET  :    pc <= 4'd0;
     default:    pc <= pc + 1'b1;  
   endcase

endmodule   
