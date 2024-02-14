initial
  begin   
    #2 $display ("pc OpCo  OSC    pos  prev error intgr vel  work res feedb alu");
 
       $monitor(
           pc, " ",     
            opCode, "  %d",
           reg9, "   ", //Oscillator position    
            reg7, " ",  //pos          
            reg6, " ",    //prev     
            reg5, " ",    //err
            reg4, "    ",    //intg
            reg1, "   ",   //velocity		
            reg3, " ",     //work
            reg2, " ",     //result
            reg8,  " ",    //feedback
            aluResult ,

            );

       end
