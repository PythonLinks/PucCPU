`timescale 1ns/100ps
`default_nettype none
`include "../../NEW/verilog/stack.sv"

//ResetCode is the instructoin opcode, or the reset code if
//  reset is pushed.
module PC (clock,
	   resetCode,
	   instructionValue,
	   registerValue,
	   pc);
   
`include "../../PBL/Modules/parameters.sv"
`include "../../PBL/Modules/instructions.sv"   


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
  wire  [PC_WIDTH-1:0]             return_to;   


initial
  begin
  pc = 0;
  end
   
 assign pcPlusOne    = pc + 1;  

MyStack stack (.clock(clock),
               .reset_code(resetCode), 
               .called_from(pc),
	       .return_to (return_to)
                );
    
//Update the program counter   
always @ (posedge clock)
   case (resetCode)
     RET:         pc <= return_to;
     CALL:        pc <= instructionValue;
     JMP:        pc <= instructionValue;
     IF0JUMP:    if (registerValue == 0) 
                     pc <= instructionValue;
                 else
                     pc <= pcPlusOne;  
     IF1JUMP:    
                 if (registerValue != 0) 
                     pc <= instructionValue;
                 else
                     pc <= pcPlusOne;
     RST  :    pc <= 4'd0;
     default:    pc <= pcPlusOne;  
   endcase // case (resetCode)

endmodule   
