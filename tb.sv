`timescale 1ns/1ps
`include "cpu.sv"

module top();
`include "parameters.h"
reg clock;
reg isReset;
reg		         	   switch;
wire [REGISTER_WIDTH-1 : 0]	   register1Value;   
wire  [PC_WIDTH-1:0]               pc;
   
CPU cpu (.clock(clock),
	 .isReset(isReset),
	 .switch (switch),
	 .pc (pc),
	 .register1Value(register1Value)	 
);

always #10 clock = ~clock; 

initial begin
    clock = 0;
    cpu.pc = 0 ;
    isReset = 1'b0;
   
    switch = 1'b1;


    #600;
    switch = ~switch;
    #350;
    isReset = 1'b1;
   
    switch = ~switch;
   #600;
   
    $finish;
    $display("End of simulation");
 
end

     
endmodule // top


