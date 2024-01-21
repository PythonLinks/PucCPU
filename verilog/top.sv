`default_nettype none

 `timescale 1ns/1ps
`ifdef IVERILOG
`include "cpu.sv"
`endif

module Top(clock,
           isReset,
	        switch,
           outputValue,
			  select
           );


`include "../../PBL/Modulesparameters.sv"

input wire clock;
input wire isReset;
input wire				    switch;
input wire [1:0] select;
output wire [REGISTER_WIDTH-1 :0]	   outputValue;  
wire        [REGISTER_WIDTH-1 :0]	   register1Value;   
wire [OPCODE_WIDTH -1:0] opCode;
 
wire [PC_WIDTH-1:0] 		   pc;
always @(*)
   case(select)
	   2'b00: outputValue <= register1Value;
	   2'b01: outputValue <= {3'b000,pc};
	   2'b11: outputValue <= {4'b0000,opCode};
	endcase	
 
   
CPU cpu (.clock(clock),
	 .isReset(~isReset),
	 .switch(switch),
	 .pc (pc),
 	 .accumulator(accumulator),
	 .register1Value(register1Value),
	 .opCode(opCode)
);

endmodule // top





























