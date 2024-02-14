
module Oscillator(clock, positionOut, feedback);
   input wire clock;
   output wire signed [7:0] positionOut;
   input wire signed [7:0]  feedback;
   wire [7:0]		    positionOutInt;
   real			    scaledPosition;
   assign scaledPosition = position*(2**7);
   assign positionOutInt = $rtoi(scaledPosition);
   assign positionOut = positionOutInt - 8'd127;
   
//  `include "../verilog/monitor/debugOscillator.sv"
//  `include "../verilog/monitor/pendulum.sv"   
   
   real	scaledRealFeedback,	  realFeedback;
   real   position, velocity,   acceleration;
   
   assign realFeedback = $itor (feedback);
   assign scaledRealFeedback = (realFeedback/(2**7)) -8'd127;
       
   parameter  neutral = 0;
   parameter  Kv = 0.01;
   parameter  Kp = 0.0005;
      
   initial
     begin
	position = 0.30;
        velocity = 0;
     end

 assign acceleration = - (Kv * velocity) 
   - Kp *(position - neutral) + 
         (scaledRealFeedback/1000.0);

 always @(posedge clock)
      begin
      position <= position + velocity;
      velocity <= velocity + acceleration;

      end	

endmodule   
