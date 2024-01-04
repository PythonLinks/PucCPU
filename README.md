# INTRODUCTION

Here is a three argument registrer CPU.
Like the risc-v, register 0 contains a zero.


## USAGE

the key command is
`./run`

It invokes the iverilog simulator, and prints out the state of various
registers.  Of particular interest is the column called Reg1.  It
counts up, it then starts shifting the values, doubling each clock
cycle, resets, then counts up again.  The current correct output is
stored in the file called output.