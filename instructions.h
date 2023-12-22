enum bit [OPCODE_WIDTH-1:0] {
  AND  = 0, 
  ANDN = 1, 
  OR   = 2, 
  ORN  = 3, 
  XOR  = 4, 
  XORN = 5, 
  NOT  = 6, 
  ADD  = 7, 
  SUB  = 8, 
  MUL  = 9, 
  DIV  = 10, 
  MOD  = 11, 
  GT   = 12, 
  GE   = 13, 
  EQ   = 14, 
  NE   = 15, 
  LE   = 16, 
  LT   = 17, 
  JMP  = 18, 
  IF0JUMP = 19,     //h13
  IF1JUMP = 20,     //h14
  CALL  = 21,      //h15
  CAL0 = 22, 
  CAL1 = 23, 
  RET  = 24,       //h18
  RET0 = 25, 
  RET1 = 26,
    RESET = 27,      
  LOADSWITCH = 28, //h1c
  INC = 29,        //h1d
  LSHIFT = 30,      //1e
  RSHIFT = 31,      //1f
  DECREMENT = 32,   //  
  LOAD = 33       //h21
 
    } opCodes;
