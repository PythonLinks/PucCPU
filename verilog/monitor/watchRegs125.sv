 
  always @(posedge clock)
    //if (pc == 29)   
      $display (pc, " ",
            //instructionValue, " %h",
            longOpCode, "  ",	    
	    reg1,"  ",
	    reg2, " ",
	    reg5, "    "
	    //bitA, " ",
	    //wordB, "      ",	    
	    //aluResult, "  ",
            //isALU, "       ",
	    //outType, " ",
            //write5,  " ",
            //registerOut	    
            );   
