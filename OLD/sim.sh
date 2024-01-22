python3  assembler/hex_generator.py assembler/opcode_list.txt assembler/instruction_list.txt  hex.hex
rm sim sim.vcd
iverilog -g2009 -Wall -s tb -o sim verilog/tb.sv 
vvp sim 
