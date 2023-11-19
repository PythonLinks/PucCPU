module ALU(accumulator, 
           register0Value,
           register1Value, 
           opCode, 
           aluResult);
   `include "parameters.h"
   input  [OPCODE_WIDTH -1:0] opCode;
   input  [REGISTER_WIDTH -1:0] accumulator;
   input  [REGISTER_WIDTH -1:0] register0Value;
   input  [REGISTER_WIDTH -1:0] register1Value;   
   output reg [REGISTER_WIDTH -1:0] aluResult;

always @ (*)   
   case (opCode)
     ADD2:         aluResult <= register0Value + register1Value;
     LSHIFT13:     aluResult <=  {accumulator[6:0],accumulator[7]};
     INCREMENT11:   aluResult <= accumulator + 1'b1;
     //AND8:         aluResult <= accumulator && registerValue;
     //OR6:          aluResult <= accumulator | registerValue;
     default:      aluResult <= accumulator;
   endcase // case (opCode)
   
endmodule
