module ALU(accumulator, registerValue, opCode, aluResult);
   `include "parameters.h"
   input  [OPCODE_WIDTH -1:0] opCode;
   input  [REGISTER_WIDTH -1:0] registerValue;
   input  [REGISTER_WIDTH -1:0] accumulator;
   output reg [REGISTER_WIDTH -1:0] aluResult;

always @ (*)   
   case (opCode)
     ADD2:         aluResult = accumulator + registerValue;
     INCREMENT7:   aluResult = accumulator + 1'b1;
     AND8:         aluResult = accumulator && registerValue;
     OR6:          aluResult = accumulator | registerValue;
     default:      aluResult = accumulator;
   endcase // case (opCode)
   
endmodule
