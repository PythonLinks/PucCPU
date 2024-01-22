//THIS ONE IS FOR MY CPU, WATCHING SHIFTS AND INCREMENTS
//`ifndef PBLSCRIPT          
initial 
  $display ("PC opCode Val R1 R2 RO Val1 Val2 NUM  ACC ALU  ");
   
initial  
  $monitor(" ",
             pc,"  %h",
             opCode, "   ", 
             instructionValue, " %h",
	     register1In, "  %h",
	     register2In, "  %h",
	     registerOut, "  ",
             register1Value, "  ",
             register2Value, "  ",	   
             reg3, " ",	   
             reg2, " ",
	     aluResult
);
