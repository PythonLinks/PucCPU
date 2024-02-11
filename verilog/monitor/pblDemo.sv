   
// FOR DEBUGGING THE PBL CPU
//INITIALIZING BIT RAM   
initial
  begin
  $display ("INITIALIZING BIT MEMORY");
  $display ("ADDRESS DATA");
  #2100
  $display ("\nINITIALIZING WORD MEMORY");
  $display ("ADDRESS DATA");
  #1750   
    //$display ("pc val OpC Reg1 Reg2 Reg5"); //bitA wordB ALU isALU typeO, registerOut");
     $display ("\nMULTIPLYING BIT BY WORD");
     
     $display ("BitA  WordB Product");

  #2600 $finish;
   
  end // initial begin
  //always @(posedge clock)
  //if (pc == 19)
  //   $display(bitA,"     ",
  //            wordB, "  ",
  //            reg5);
   

