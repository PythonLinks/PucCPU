`default_nettype none

`timescale 1ns/1ps
`include "cpu.sv"

module top();
`include "parameters.h"
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

    #300;
    switch = ~switch;
   
    #350;
    isReset = 1'b1;
    #20 isReset = 1'b0;   
    
    //switch = ~switch;
   #1200;
   
    $finish;
    $display("End of simulation");
 
end

     
endmodule // top


