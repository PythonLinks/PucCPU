//`define PBL
module crtl_mod_tb;

	parameter PC_WIDTH = 5;
	parameter REGISTER_WIDTH = 8;
	parameter NUMBER_OF_REGISTERS = 8;

	//Instruction is 4 bits instructin, 4 bits register, 8 bits address 
	parameter INSTRUCTION_WIDTH = 40; 
	parameter OPCODE_WIDTH = 6;
	parameter REGISTER_ID_WIDTH = 8;
	parameter VALUE_WIDTH = 8;

	parameter TRUE   = 1'b1;
	parameter FALSE  = 1'b0;

	parameter INSTR_ADDR_SIZE = 5;
	parameter INSTR_SIZE = 40;
	reg clk, rst, zero_flag;
	reg [INSTR_ADDR_SIZE - 1:0] jmp_addr, ret_addr;
	wire [INSTR_ADDR_SIZE - 1:0] instr_addr;
	wire [INSTR_SIZE - 1:0]instruction; 
	wire [5:0] op_code;
	wire [7:0] source1, source2, destination;
	wire [1:0] source1_choice, source2_choice, destination_choice;
	wire push, pop, cal, jmp, ret;	

	pc#(
		.INSTR_ADDR_SIZE(INSTR_ADDR_SIZE)
	)pc(
		//inputs
		.clk(clk),
		.rst(rst), 
		.jmp(jmp), // jmp == 1'b1 set counter to value specyfied in jmp_addr 
		.ret(ret), // specyfies if we use return address and sets values of instr_addr to ret_addr
		.jmp_addr(jmp_addr), //
		.ret_addr(ret_addr),
		.instr_addr(instr_addr) // current instruction address (which instruction is currently used by alu)
	);		

	MEMORY memory(
		.pc(instr_addr),
		.instruction(instruction)
	);	
	
	decoder#(
		.PC_WIDTH(PC_WIDTH),
		.INSTR_ADDR_SIZE(INSTR_ADDR_SIZE),
		.OPCODE_WIDTH(OPCODE_WIDTH),
		.VALUE_WIDTH(VALUE_WIDTH),
		.INSTRUCTION_WIDTH(INSTRUCTION_WIDTH)
	)
	decoder(
		.instr(instruction),
		.zero_flag(zero_flag),//instruction code from hex file
		//outputs
		.op_code(op_code), //operation code if possible 4 bits
		.source1(source1),
		.source2(source2), //addresses for alu inputs 
		.destination(destination), //address for alu output 
		.source1_choice(source1_choice), //source one choice 
		.source2_choice(source2_choice), //source two choice
		.destination_choice(destination_choice),
		.jmp_addr(jmp_addr),
		.jmp(jmp), //jump to instruction given by jmp_addr
		.cal(cal), //jump to  instruction given by jmp_addr adn save return address in stack
		.ret(ret),  //jump to return address
		.push(push), //push registers to stack	
		.pop(pop)   //pop stack registers
	);
	
	linked_reg#(
		.PC_SIZE(5)
	)linked_reg(
		.clk(clk), 
		.ret(ret), 
		.cal(cal),
		.instr_addr(instr_addr),
		.ret_addr(ret_addr)
	);

	always begin 
		#5 clk = ~clk;
	end
	initial begin
		clk = 1;
		rst = 1;
		zero_flag = 1;
		#10
		rst = 0;
		#100
		$finish;
	end

	initial begin
		$dumpfile("sim.vcd");
		$dumpvars(0, crtl_mod_tb);
		$dumpon;
	end

endmodule
