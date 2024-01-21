//THIS ONE IS FOR MY CPU, WATCHING SHIFTS AND INCREMENTS
//`ifndef PBLSCRIPT          
initial 
  $display ("SW OP   PC Val R1 R2 RO Val1 Val2  RG1 RG2 isALU  ");
   
initial  
  $monitor(" ",
             switch, " %h",
             opCode, "   ", 
             pc,"  %h",
             instructionValue, " %h",
	     register1In, "  %h",
	     register2In, "  %h",
	     registerOut, "  ",
             register1Value, "  ",
             register2Value, "  ",	   
             reg1, " ",
	     reg2, "    ",
	     isALU
);
