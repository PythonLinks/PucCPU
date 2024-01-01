// Write your modules here!
module stack(clock, resetCode, pc, instructionValue, registerValue);
  parameter INSTRUCTION_WIDTH = 32; 
  parameter VALUE_WIDTH = 8;
  parameter OPCODE_WIDTH = 8;
    parameter REGISTER_WIDTH = 8;
  parameter PC_WIDTH = 5;

  input clock;
  input wire  [OPCODE_WIDTH - 1:0]       resetCode;
  input wire [VALUE_WIDTH - 1 :0]        instructionValue;
  input wire [VALUE_WIDTH - 1 :0]        registerValue;   
  output reg  [PC_WIDTH-1:0]             pc;
  wire [PC_WIDTH - 1 : 0]                pcPlusOne;
  
  //NEXT we have the arguments for managing the stack 
  reg  [PC_WIDTH-1:0]          returnStack[16];
  reg  [3:0]                   stackOffset;
  reg  [3:0]                   previousStackOffset;  
  wire [PC_WIDTH - 1 : 0]     returnV;
  always @ (posedge clock) 
   case (resetCode)
     5'd1:         pc <= returnStack[stackOffset - 1'b1];
     5'd2:         pc <= instructionValue[PC_WIDTH-1:0];
     5'd3:    if (registerValue == 0) 
                      pc <= instructionValue;
                   else
                      pc <= pc + 1'b1;  
     5'd4:    if (registerValue != 0) 
                      pc <= instructionValue;
                      else
                      pc <= pc + 1;       
     5'd5  :    pc <= 4'd0;
     default:    pc <= pc + 1'b1;  
   endcase
  
endmodule
