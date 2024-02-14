
module Oscillator(clock, positionOut, feedback);
   input wire clock;
   output wire [7:0] positionOut;
   input wire signed [7:0]  feedback;
   reg signed [31:0]		    position;
   reg signed [31:0]               velocity;
   wire signed [31:0]	    acceleration;
//  `include "../verilog/monitor/debugOscillator.sv"

   parameter  neutral = 2**30;
   parameter  Kv = 0.002;
   parameter  Kp = 0.0005;

   assign positionOut = position[31:24];
   
   initial
     begin
	position = (2**31 -1)/5;
        velocity = 0;
     end

 assign acceleration = 
            - (Kv * velocity) 
            - Kp *(position - neutral) + 
	      feedback *5000;
   

 always @(posedge clock)
      begin
      position <= position + velocity;
      velocity <= velocity + acceleration;

      end	

endmodule   
