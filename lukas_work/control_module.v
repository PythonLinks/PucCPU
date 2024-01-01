module control_module (
	//inputs 
	clk, rst, zero_flag,
	
	//outputs
	op_code,
	source1, source2, destination, 
	source1_choice, source2_choice, destination_choice,
	push, pop
);
	`include "instructions.h"
	//`include "parameters.h"
	parameter PC_WIDTH = 5;
	parameter REGISTER_WIDTH = 8;
	parameter NUMBER_OF_REGISTERS = 8;

	//Instruction is 4 bits instructin, 4 bits register, 8 bits address 
	parameter INSTRUCTION_WIDTH = 40; 
	parameter OPCODE_WIDTH = 6;
	parameter REGISTER_ID_WIDTH = 8;
	parameter VALUE_WIDTH = 8;


	input clk, rst, zero_flag;
	output [OPCODE_WIDTH - 1:0] op_code;
	output [VALUE_WIDTH - 1:0] source1, source2, destination;
	output [1:0] source1_choice, source2_choice, destination_choice;
	output push, pop;
	wire jmp, ret, cal;
	wire [PC_WIDTH - 1:0] jmp_addr, instr_addr, ret_addr;
	wire [INSTRUCTION_WIDTH - 1:0] instr;
	
	
endmodule 
