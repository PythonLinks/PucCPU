`timescale 1ns/100ps
`default_nettype none

`define DEMO 1
`define PBL 1

`include "../../NEW/verilog/cpu.sv"


module tb();
`include "../../PBL/Modules/parameters.sv"
reg clock;
reg isReset;
reg		         	   switch;
wire [REGISTER_WIDTH-1 : 0]	   register1Value;   
   
CPU cpu (.clock(clock),
	 .isReset(isReset),
	 .switch (switch),
	 .register1Value(register1Value)

);

always #10 clock = ~clock; 

initial begin
    clock = 0;
    isReset = 1'b0;
    switch = 1'b0;

    #300;
    switch = ~switch;

    #350;
    `ifndef PBL
    //isReset = 1'b1;
    //#20 isReset = 1'b0;   
    switch = ~switch;
    `endif
   `ifdef PBL
   #100000 $finish;
   `else
   #10000 $finish;
   `endif   
   
end

     
endmodule // top


