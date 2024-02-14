
   initial
     begin
     #5 $display("\nposition        velocity      accel    feed reg8 posOut");	
     $monitor ( oscillator.position,  " ",
	        oscillator.velocity , " ",
	        oscillator.acceleration, " ",
	        oscillator.feedback, " ",
	        reg8, " ",
               oscillator.positionOut);
     end

