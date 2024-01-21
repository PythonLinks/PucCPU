   
// FOR DEBUGGING THE PBL CPU
//INITIALIZING BIT RAM   
initial
  begin
  $display ("INITIALIZING BIT MEMORY");
  $display ("ADDRESS DATA");
  #160
  $display ("INITIALIZING WORD MEMORY");
  $display ("ADDRESS DATA");
  #160   
    //$display ("pc val OpC Reg1 Reg2 Reg5"); //bitA wordB ALU isALU typeO, registerOut");
     $display ("BitA  WordB Product");
     

  #659 $finish;
   
  end // initial begin
  always @(posedge clock)
  if (pc == 19)
     $display(bitA,"     ",
              wordB, "  ",
              reg5);
   

