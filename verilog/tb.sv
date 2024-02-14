`timescale 1ns/100ps
`default_nettype none

`define PBL 1

//`include "../../WPDM/verilog/cpu.sv"


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
/*
    $display ("Position, Velocity Acceleration");

   $monitor ("%5.4f", 
             position, 
             "  %5.4f",  
            velocity, 
            "  %5.4f", 
            acceleration);
  */ 
    clock = 0;
    isReset = 1'b0;
   #1 $dumpfile("out.vcd");
   $dumpvars(0, tb);
   $dumpon;
   
    #100000 $finish;
end

     
endmodule // top


