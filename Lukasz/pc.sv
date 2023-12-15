module pc#(
    parameter INSTR_ADDR_SIZE = 5
) ( 
   CLK,
   OP_CODE, 
   JMP_ADDR, 
   RET_ADDR, 
   INSTR_ADDR
);
    input CLK;
    input [1:0] OP_CODE;
    input [INSTR_ADDR_SIZE - 1:0] JMP_ADDR, RET_ADDR;
    output reg [INSTR_ADDR_SIZE - 1:0] INSTR_ADDR;

    always @(posedge CLK) 
      case (OP_CODE)
        2'd0:  INSTR_ADDR <= {INSTR_ADDR_SIZE{1'b0}}; 
        2'd1: INSTR_ADDR <= JMP_ADDR;
        2'd2: INSTR_ADDR <= RET_ADDR;
        default: INSTR_ADDR <= INSTR_ADDR + 1;
     
      endcase 
endmodule
