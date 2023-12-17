 module pc#(
    parameter INSTR_ADDR_SIZE = 8
) ( 
   CLK,
   jump_code, 
   jump_address, 
   return_address, 
   instruction_address
);

   enum bit [1:0] {
    RESET=2'd0,      
    JUMP=2'd1,    
    RET=2'd2,
    DEFAULT = 2'd3         
    } opCodes;
   
    input CLK;
   input [1:0] jump_code;
    input [INSTR_ADDR_SIZE - 1:0] jump_address, return_address;
    output reg [INSTR_ADDR_SIZE - 1:0] instruction_address;

    always @(posedge CLK) 
      case (jump_code)
        RESET:  instruction_address <= {INSTR_ADDR_SIZE{1'b0}}; 
        JUMP:   instruction_address <= jump_address;
        RET:    instruction_address <= return_address;  
        default: instruction_address<= instruction_address + 1;
     
      endcase 
endmodule
