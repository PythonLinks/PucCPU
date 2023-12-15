module pc#(
    parameter INSTR_ADDR_SIZE = 5
) (
    //inputs
    CLK, RST, 
    JMP, // JMP == 1'b1 set counter to value specyfied in JMP_ADDR 
    RET, // specyfies if we use return address and sets values of INSTR_ADDR to RET_ADDR
    JMP_ADDR, //
    RET_ADDR,
    INSTR_ADDR // current instruction address (which instruction is currently used by ALU)
);
    input CLK, RST, JMP, RET;
    input [INSTR_ADDR_SIZE - 1:0] JMP_ADDR, RET_ADDR;
    output reg [INSTR_ADDR_SIZE - 1:0] INSTR_ADDR;

    always @(posedge CLK)begin 
        if (RST) begin 
            INSTR_ADDR <= {INSTR_ADDR_SIZE{1'b0}}; 
        end
        else if (JMP) begin 
            INSTR_ADDR <= JMP_ADDR;
        end
        else if (RET) begin 
            INSTR_ADDR <= RET_ADDR;
        end
        else begin 
            INSTR_ADDR <= INSTR_ADDR + 1;
        end
    end 
endmodule
