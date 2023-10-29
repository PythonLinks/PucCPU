module ALU(accumulator, register1, opCode, aluResult);
   `include "parameters.h"
   input  [OPCODE_WIDTH -1:0] opCode;
   input  [REGISTER_WIDTH -1:0] register1;
   input  [REGISTER_WIDTH -1:0] accumulator;
   output reg [REGISTER_WIDTH -1:0] aluResult;

always @ (*)   
   case (opCode)
     ADD:         aluResult = accumulator + register1;
     INCREMENT:   aluResult = accumulator + 1;
     AND:         aluResult = accumulator && register1;
     OR:          aluResult = accumulator | register1;
     NOT:         aluResult = !accumulator;
   endcase // case (opCode)
   
endmodule
