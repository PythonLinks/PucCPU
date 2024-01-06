import re

input_file_path = "instructions.h"
output_file_path = "gtkwave_filter.txt"

# Regular expression to match enum entries
enum_entry_pattern = re.compile(r'\b(\w+)\s*=\s*(\d+)')

opcodes = {}

# Read the input file and extract enum entries
with open(input_file_path, 'r') as file:
    inside_enum = False
    for line in file:
        if 'enum bit' in line:
            inside_enum = True
            continue
        elif '}' in line and inside_enum:
            break
        elif inside_enum:
            match = enum_entry_pattern.search(line)
            if match:
                op_name, op_value = match.groups()
                opcodes[op_name] = int(op_value)

# Find the maximum length of binary values
max_length = len(bin(max(opcodes.values()))[2:])

# Write to the output file
with open(output_file_path, 'w') as output_file:
    for op_name, op_value in opcodes.items():
        binary_value = format(op_value, f'0{max_length}b')
        output_file.write(f"{binary_value} {op_name}\n")

print(f"Generated {output_file_path} successfully.")
