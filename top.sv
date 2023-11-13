`timescale 1ns/1ps
`ifdef IVERILOG
`include "cpu.sv"
`endif

module Top(clock,
           isReset,
	        switch,
           outputValue,
           );

   
`include "parameters.h"

input reg clock;
input wire isReset;
input reg				    switch;
wire        [REGISTER_WIDTH-1 :0]	   register1Value;   
output wire [REGISTER_WIDTH-1 :0]	  outputValue;   
wire [PC_WIDTH-1:0] 		   pc;
assign outputValue = {4'b0,pc};

   
CPU cpu (.clock(clock),
	 .isReset(isReset),
	 .pc (pc),
	 .switch (switch),
	 .register1Value(registerValue)
);

endmodule // top


