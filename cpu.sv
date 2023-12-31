`default_nettype none


//`define IVERILOG

//`ifdef IVERILOG
`include "memory.sv"
`include "alu.sv"
`include "pc.sv"
`include "parse.sv"
//`endif


`ifdef PBL
`include "../PBLcpu/Modules/ram_bit.v"
`include "../PBLcpu/Modules/alu.v"
`include "../PBLcpu/Modules/flag_reg.v"
`endif
  
module CPU(clock,
	   isReset,
	   switch,
	   pc,
	   register1Value,
);

`include "parameters.h"



   
   input  wire		               clock;
   input  wire		               isReset;
   input  wire			       switch;
   output wire  [REGISTER_WIDTH-1:0]   register1Value;
   wire  [REGISTER_WIDTH-1:0]          register2Value;
   wire        [REGISTER_WIDTH -1:0]   aluResult;
   reg  [REGISTER_WIDTH-1:0]   registers[NUMBER_OF_REGISTERS-1:0];


   output wire  [PC_WIDTH-1:0]         pc;
   
   //And now for the instruction parsing   
   wire        [INSTRUCTION_WIDTH-1:0] instruction;
   wire [OPCODE_WIDTH-1:0]             opCode;
   wire [7:0]			       address1In;
   wire [7:0]			       address2In;
   wire [7:0]			       addressOut;   

   wire [1:0]			       address1Type;
   wire [1:0]			       address2Type;
   wire [1:0]			       outType;   
   
   wire        [2:0]		       register1In;
   wire        [2:0]		       register2In;
   wire        [2:0]		       registerOut;   

   wire [VALUE_WIDTH - 1 :0]   instructionValue;
  
  //Since we can get a reset instruction
  //Or a reset by pushbutton, we have to update the instruction.  
  wire  [OPCODE_WIDTH - 1:0] 	 resetCode;   
  assign resetCode = isReset ? RESET : opCode; 
   
   
  Parser parser(instruction,
		opCode,
		address1In,
		address2In,
		addressOut,
		address1Type,
		address2Type,
		outType,
		register1In,
		register2In,
		registerOut,
		instructionValue);
   
   
   assign register1Value = registers[register1In];
   assign register2Value = registers[register2In];   
   
   PC pcModule (.clock(clock),
		.resetCode (resetCode),
		.instructionValue(instructionValue),
		.registerValue(register2Value),
		.pc (pc));
   
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));


`ifdef PBL


// Here we define the bit memory

wire port_a_out;
wire port_b_out;
wire port_c_data;
wire port_c_we;

assign port_c_we = (  outType == useBit) ? TRUE: FALSE;
   
ram_bit bitMemory(
    .clk(clock),

    .port_a_address(address1In),
    .port_a_out(port_a_out),

    .port_b_address(address2In),
    .port_b_out(port_b_out),

    .port_c_address(addressOut),
    .port_c_data(aluResult[0]),
    .port_c_we(port_c_we)
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
   assign longOpCode = {3'b000,opCode};
   
alu ALU 
   (
    .op_code(longOpCode),
    .source1_choice(address1Type),
    .bit_mem_a(port_a_out),
    .word_mem_a(ZERO),
    .rf_a(register1Value),
    .imm_a(instructionValue),
    .source2_choice(address2Type),
    .bit_mem_b(port_b_out),
    .word_mem_b(ZERO),
    .rf_b(register2Value),
    .imm_b(instructionValue),
    .alu_c_in(oldCarryFlag),
    .alu_b_in(oldBorrowFlag),
    .alu_c_out(newCarryFlag),
    .alu_b_out(newBorrowFlag),
    .alu_out(aluResult)
);

`else	       
   ALU alu (
            .opCode (opCode), 
            .register1Value (register1Value),
            .register2Value (register2Value),
	    .instructionValue (instructionValue),
	    .switch (switch),
            .aluResult(aluResult));

`endif // !`ifdef PBL
	       
   reg					 isALU;
   assign isALU = ((opCode == ADD) |
                   (opCode == LSHIFT ) | 
                   (opCode == RSHIFT) | 
                   (opCode == INC) | 
                   (opCode == LOAD) | 
                   (opCode == LOADSWITCH) | 
                   (opCode == DECREMENT) )
                   ;
   
//Sadly generate does not seem to work in iVerilog
always @(posedge clock) begin
  registers [0] <= 0;   
  if ((registerOut == 1) & isALU)     
         registers[1] <= aluResult;
  if ((registerOut == 2) & isALU)     
         registers[2] <= aluResult;
  if ((registerOut == 3) & isALU)     
         registers[3] <= aluResult;
  if ((registerOut == 4) & isALU)     
         registers[4] <= aluResult;
  if ((registerOut == 5) & isALU)     
         registers[5] <= aluResult;
  if ((registerOut == 6) & isALU)     
         registers[6] <= aluResult;
  if ((registerOut == 7) & isALU)     
         registers[7] <= aluResult;
end   

// FOR DEBUGGING THE PBL CPU   
initial
  $display ("pc val add type aluIn Result    we");

   
initial 
  $monitor (pc, " ",
            instructionValue, 
	    addressOut, "    ",
            outType, " ",
	    ALU.in_a, "      ",
	    aluResult, "       ",
	    port_c_we
            );
   

//THIS ONE IS FOR MY CPU, WATCHING SHIFTS AND INCREMENTS
/*   
initial 
  $display ("SW OP  PC Val R1 R2 RO Val1 Val2 ALU RG1 RG2 SOFFSET isALU  ");
   
initial  
  $monitor(
             switch, " %h",
             opCode, "   ", 
             pc,"  %h",
             instructionValue, " %h",
	     register1In, "  %h",
	     register2In, "  %h",
	     aluResult, " ",
	     registerOut, "  ",
             register1Value, "  ",
             register2Value, "  ",	   
             register1Value, " ",
	     register2Value, " ",
	     isALU
	     
);

//THIS ONE IS FOR TESTING THE REGISTER VALUES BEING SET

initial 
  $display ("PC   OP R1 R2 RO   isALU VAL  ALU         Reg1      Reg2");
   
initial
   $monitor( pc, " ", 
             opCode, "   %h", 
	     register1In, " %h",
	     register2In, " %h",
	     registerOut, "       ",
	     isALU, " " ,
	     instructionValue, " ",
             aluResult, " ",
	     registers [1], " ",
	     registers [2]
             );
*/
   
endmodule      

