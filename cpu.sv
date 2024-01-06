`default_nettype none

`define IVERILOG

`ifdef IVERILOG
`include "memory.sv"
`include "pc.sv"
`include "parse.sv"


`ifdef PBL
`include "../Modules/ram_bit.v"
`include "../Modules/ram_word.v"
`include "../Modules/alu.v"
`include "../Modules/flag_reg.v"
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
                             address2In;

 assign realAddressOut = (registerHasAddress[0]) ? 
                             registers[3]:
                             addressOut;   
   

 
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
		.registerValue(register1Value),
		.pc (pc));
   
   MEMORY memory ( .pc(pc),
		   .instruction (instruction));

wire  registerWriteEnable;

`ifdef PBL
`include "orszuk.v"
`else	       
   ALU alu (
            .opCode (opCode), 
            .register1Value (register1Value),
            .register2Value (register2Value),
	    .instructionValue (instructionValue),
	    .switch (switch),
            .aluResult(aluResult));
assign registerWriteEnable = TRUE;
      
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

`ifdef PBL
`include "monitor/pblDemo.sv"   
`else

`include "monitor/debugMyCPU.sv"
//`include "monitor/watchRegs125.sv"   
 
//`include "monitor/testRegisters.sv"
`endif
   
endmodule      

