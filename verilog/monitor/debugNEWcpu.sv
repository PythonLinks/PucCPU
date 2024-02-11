//THIS ONE IS FOR MY CPU, WATCHING SHIFTS AND INCREMENTS
//`ifndef PBLSCRIPT          
initial 
  $display ("PC opCode Val R1 R2 RO Val1 Val2   R3  R4  R5  R6 ALU  ");
   
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
             reg4, " ",
             reg5, " ",
             reg6, " ",	   	   
	     aluResult
);
