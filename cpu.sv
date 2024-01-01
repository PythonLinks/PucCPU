`default_nettype none


`define IVERILOG

`ifdef IVERILOG
`include "memory.sv"
`include "pc.sv"
`include "parse.sv"


`ifdef PBL
`include "../PBLcpu/Modules/ram_bit.v"
`include "../PBLcpu/Modules/ram_word.v"
`include "../PBLcpu/Modules/alu.v"
`include "../PBLcpu/Modules/flag_reg.v"
`else
  `include "alu.sv"
`endif
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
   wire        [2:0]		       registerHasAddress;      

   wire [VALUE_WIDTH - 1 :0]   instructionValue;
  
  //Since we can get a reset instruction
  //Or a reset by pushbutton, we have to update the instruction.  
  wire  [OPCODE_WIDTH - 1:0] 	 resetCode;   
  assign resetCode = isReset ? RESET : opCode; 
  wire [REGISTER_WIDTH -1 : 0]	   realAddress1In;
  wire [REGISTER_WIDTH -1 : 0]	   realAddress2In;
  wire [REGISTER_WIDTH -1 : 0]	   realAddressOut;   
 
 assign realAddress1In= (registerHasAddress[2]) ? 
                             registers[1]:
                             address1In ;

 assign realAddress2In = (registerHasAddress[1]) ? 
                             registers[2]:
                             address2In ;

 assign realAddressOut = (registerHasAddress[0]) ? 
                             registers[3]:
                             addressOut ;   
   

 
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
		registerHasAddress,
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
wire  wordWriteEnable;
wire  registerWriteEnable;
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
`ifdef PBL
   assign isALU = (opCode < 6'h22);
`else
   assign isALU = ((opCode == ADD) |
                   (opCode == LSHIFT ) | 
                   (opCode == RSHIFT) | 
                   (opCode == INC) | 
                   (opCode == LOAD) | 
                   (opCode == LOADSWITCH) | 
                   (opCode == DECREMENT) )
                   ;
`endif
   
//Sadly generate does not seem to work in iVerilog
always @(posedge clock) begin
  if (TRUE) 
         registers [0] <= 0;   
  if ((registerOut == 1) & isALU & registerWriteEnable)     
         registers[1] <= aluResult;
  if ((registerOut == 2) & isALU & registerWriteEnable)
         registers[2] <= aluResult;
  if ((registerOut == 3) & isALU & registerWriteEnable)     
         registers[3] <= aluResult;
  if ((registerOut == 4) & isALU & registerWriteEnable)     
         registers[4] <= aluResult;
  if ((registerOut == 5) & isALU & registerWriteEnable)
         registers[5] <= aluResult;
  if ((registerOut == 6) & isALU & registerWriteEnable)     
         registers[6] <= aluResult;
  if ((registerOut == 7) & isALU & registerWriteEnable)     
         registers[7] <= aluResult;
end   

   wire [7:0] reg1, reg2, reg3, reg4, reg5;
   assign reg1 = registers[1];
   assign reg2 = registers[2];
   assign reg3 = registers[3];
   assign reg4 = registers[4];
   assign reg5 = registers[5];   

     
// FOR DEBUGGING THE PBL CPU
//INITIALIZING BIT RAM   
initial
  begin
  $display ("INITIALIZING BIT MEMORY");
  $display ("ADDRESS DATA");
  #160
  $display ("INITIALIZING WORD MEMORY");
  $display ("ADDRESS DATA");
  #160   
    //$display ("pc val OpC Reg1 Reg2 Reg5"); //bitA wordB ALU isALU typeO, registerOut");
     $display ("BitA  WordB Product");
     

  #659 $finish;
   
  end // initial begin
  always @(posedge clock)
  if (pc == 19)
     $display(bitA,"     ",
              wordB, "  ",
              reg5);
   
/* 
  $display (pc, " ",
            //instructionValue, " %h",
            longOpCode, "  ",	    
	    reg1,"  ",
	    reg2, " ",
	    reg5, "    "
	    //bitA, " ",
	    //wordB, "      ",	    
	    //aluResult, "  ",
            //isALU, "       ",
	    //outType, " ",
            //write5,  " ",
            //registerOut	    
            );   
*/

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
	     reg1, " ",
	     reg2
             );
*/
   
endmodule      

