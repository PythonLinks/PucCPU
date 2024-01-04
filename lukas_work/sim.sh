python3  scripts/hex_generator.py scripts/opcode_list.txt scripts/instruction_list.txt  hex.hex
rm sim sim.vcd
iverilog -g2009 -Wall -s crtl_mod_tb2 -o sim control_module.sv crtl_mod_tb2.sv decoder.sv linked_reg.sv memory.sv parameters.h pc2.sv instructions.sv 
vvp sim 
