`default_nettype none

module ALU(
           register1Value,
           register2Value,
           opCode, 
           aluResult);
   `include "parameters.h"
   input  [OPCODE_WIDTH -1:0] opCode;
   input  [REGISTER_WIDTH -1:0] register1Value;   
   input  [REGISTER_WIDTH -1:0] register2Value;
   output reg [REGISTER_WIDTH -1:0] aluResult;

always @ (*)   
   case (opCode)
     ADD2:         aluResult <= register1Value + register2Value;
     LSHIFT13:     aluResult <=  {register1Value[6:0],register1Value[7]};
     RSHIFT15:     aluResult <=  {register1Value[0], register1Value[7:1]};
     INCREMENT11:   aluResult <= register1Value + 1'b1;
     DECREMENT14:   aluResult <= register1Value -  1'b1;     
     //AND8:         aluResult <= register1Value && register2Value;
     //OR6:          aluResult <= register1Value | register2Value;
     default:      aluResult <= 0;
   endcase // case (opCode)
   
endmodule
