wire  wordWriteEnable;
wire  bitWriteEnable;

assign bitWriteEnable    = (  outType == useBit) ? TRUE: FALSE;
assign wordWriteEnable   = (  outType == useMemory) ? TRUE: FALSE;
assign registerWriteEnable = (  outType == useRegister) ? TRUE: FALSE;   
   

wire [MEMORY_WIDTH-1:0] wordA;
wire [MEMORY_WIDTH-1:0] wordB;
   
// Here we have the word memory
ram_word wordMemory (
    .clk(clock),
    .port_a_address(realAddress1In),
    .port_a_out(wordA),
    .port_b_address(realAddress2In),
    .port_b_out(wordB),
    .port_c_address(realAddressOut),
    .port_c_data(aluResult),
    .port_c_we(wordWriteEnable)
);

   
// Here we define the bit memory

wire bitA;
wire bitB;
wire port_c_data;

   
ram_bit bitMemory(
    .clk(clock),

    .port_a_address(realAddress1In),
    .port_a_out(bitA),

    .port_b_address(realAddress2In),
    .port_b_out(bitB),

    .port_c_address(realAddressOut),
    .port_c_data(aluResult[0]),
    .port_c_we(bitWriteEnable)
);


// And here we define the flags   
wire oldCarryFlag;
wire oldZFlag;
wire oldBorrowFlag;
wire newCarryFlag;
wire newBorrowFlag; 
wire newZFlag;
	       
flag_reg flags(
    .clk(clock),
    .flag_rst(isReset),
    .flag_c_in(newCarryFlag),
    .flag_z_in(newZFlag),
    .flag_b_in(newBorrowFlag),
    .flag_c(oldCarryFlag),
    .flag_z(oldZFlag),
    .flag_b(oldBorrowFlag)
);


//And now the alu.    
   wire [7:0] longOpCode;
   assign longOpCode = {2'b00,opCode};
   
alu ALU 
   (
    .op_code(longOpCode),
    .source1_choice(address1Type),
    .bit_mem_a(bitA),
    .word_mem_a(wordA),
    .rf_a(register1Value),
    .imm_a(instructionValue),
    .source2_choice(address2Type),
    .bit_mem_b(bitB),
    .word_mem_b(wordB),
    .rf_b(register2Value),
    .imm_b(instructionValue),
    .alu_c_in(oldCarryFlag),
    .alu_b_in(oldBorrowFlag),
    .alu_c_out(newCarryFlag),
    .alu_b_out(newBorrowFlag),
    .alu_out(aluResult)
);
