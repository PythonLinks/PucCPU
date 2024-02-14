`timescale 1ns/100ps
`default_nettype none

`include "../verilog/globalparameters.vh"

`define IVERILOG
`ifdef IVERILOG
`include "../../PBL/Modules/memory.sv"
`include "../verilog/pc.sv"
`include "../verilog/parse.sv"
`include "../verilog/oscillator.sv"

`include "../../PBL/Modules/ram_bit.sv"
`include "../../PBL/Modules/ram_word.sv"
`include "../../PBL/Modules/alu.sv"
`include "../../PBL/Modules/flag_reg.sv"
`endif
`include "../../PBL/Modules/instructions.sv"

module CPU(clock,
	   isReset,
	   switch,
	   pc,
	   register1Value,
);

`include "../../PBL/Modules/parameters.sv"

`ifdef DEMO1
`include "../../WPDM/verilog/monitor/pblDemo.sv"   
`endif

   
   input  wire		               clock;
   input  wire		               isReset;
   input  wire			       switch;
   output wire  signed [REGISTER_WIDTH-1:0]   register1Value;
   wire  signed [REGISTER_WIDTH-1:0]          register2Value;
   wire  signed      [REGISTER_WIDTH -1:0]   aluResult;
   reg  signed [REGISTER_WIDTH-1:0]   registers[NUMBER_OF_REGISTERS-1:0];


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
   
   wire        [LOG_OF_REGISTERS-1:0]  register1In;
   wire        [LOG_OF_REGISTERS-1:0]  register2In;
   wire        [LOG_OF_REGISTERS-1:0]  registerOut;
   wire        [LOG_OF_REGISTERS-1:0]  registerHasAddress;      

   wire signed [VALUE_WIDTH - 1 :0]   instructionValue;
  
  //Since we can get a reset instruction
  //Or a reset by pushbutton, we have to update the instruction.  
  wire  [OPCODE_WIDTH - 1:0] 	 resetCode;   
  assign resetCode = isReset ? RST : opCode; 
  wire [REGISTER_WIDTH -1 : 0]	   realAddress1In;
  wire [REGISTER_WIDTH -1 : 0]	   realAddress2In;
  wire [REGISTER_WIDTH -1 : 0]	   realAddressOut;   

assign realAddressOut =  
      (opCode == LD)? 
      (registerHasAddress[0] ?  registers[registerOut]: addressOut) :   	        addressOut;   	    

assign realAddress1In = 
     (opCode == MUL) ?
     (registerHasAddress[1] ? registers[register1In]: address1In):		  
     address1In;

assign realAddress2In = 
     (opCode == MUL) ?
     (registerHasAddress[0] ? registers[register2In]: address2In):		  
     address2In ;

`ifdef DEMO1   
always @( reg6)
  $display ( bitA, "     ", wordB, "    ", reg6);
`endif   

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
 
 `include "../../WPDM/verilog/orszuk.v"

 reg                                     isALU;

     assign isALU = (opCode < 6'h22);

   wire  signed [7:0]			 positionOut;
       
always @(posedge clock)
    registers[9] <= positionOut;
   
Oscillator oscillator(clock, positionOut, registers[8]);
//Oscillator oscillator(clock, positionOut, 8'b0);   

//  `include "../verilog/monitor/pendulum.sv"   
  `include "../verilog/monitor/pdi.sv"


   wire signed [7:0]			 registerWriteValue;
    
//assign registerWriteValue = (opCode == LD)? instructionValue: aluResult;
assign registerWriteValue =  aluResult;   
    
 //Sadly generate does not seem to work in iVerilog
 always @(posedge clock) begin
   if (TRUE) 
          registers [0] <= 0;   
   if ((registerOut == 1) & registerWriteEnable)     
          registers[1] <= registerWriteValue;
   if ((registerOut == 2) & registerWriteEnable)
          registers[2] <= registerWriteValue;
   if ((registerOut == 3) & registerWriteEnable)     
          registers[3] <= registerWriteValue;
   if ((registerOut == 4) & registerWriteEnable)     
          registers[4] <= registerWriteValue;
   if ((registerOut == 5) & registerWriteEnable)
          registers[5] <= registerWriteValue;
   if ((registerOut == 6) & registerWriteEnable)     
          registers[6] <= registerWriteValue;
   if ((registerOut == 7) & registerWriteEnable)     
          registers[7] <= registerWriteValue;
   if ((registerOut == 8) & registerWriteEnable)     
          registers[8] <= registerWriteValue;    
 end   
   
initial
  begin
     registers [6] = 30;//previous position.
     registers [4] = 0;//integral.
  end


   
   wire signed [7:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9;
   assign reg1 = registers[1];
   assign reg2 = registers[2];
   assign reg3 = registers[3];
   assign reg4 = registers[4];
   assign reg5 = registers[5];
   assign reg6 = registers[6];
   assign reg7 = registers[7];
   assign reg8 = registers[8];   
   assign reg9 = registers[9];           

   wire	      bitMem;
   wire [7:0] wordMem;



//`include "../../WPDM/verilog/monitor/debugMyCPU.`
   
//`include "../../WPDM/verilog/monitor/debugNEWcpu.sv"   

//`include "../../WPDM/verilog/monitor/watchRegs125.sv"   
 
//`include "../../WPDM/verilog/monitor/testRegisters.sv"
   
endmodule      

