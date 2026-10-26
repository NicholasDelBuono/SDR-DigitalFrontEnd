import math

# This script can be used to generate a LUT with different parameters

# --- NCO Hardware Configuration ---
N_LUT_ADDR = 12  # Truncated phase width for LUT addressing (4096 points)
N_DATA_OUT = 16  # Quantized output width (16-bit signed)

# --- Derived Parameters ---
N_LUT_line = 2**N_LUT_ADDR
lsb = 1 / (2**(N_DATA_OUT - 1) - 1)

fname = "LUT.vhd"

with open(fname, "w") as out_file:
    out_file.write("library IEEE;\n")
    out_file.write("use IEEE.std_logic_1164.all;\n")
    out_file.write("use IEEE.numeric_std.all;\n\n")
    
    out_file.write("entity LUT is\n")
    out_file.write("  port (\n")
    out_file.write(f"        addr : in  std_logic_vector({N_LUT_ADDR-1} downto 0);\n")
    out_file.write(f"        do   : out std_logic_vector({N_DATA_OUT-1} downto 0)\n")
    out_file.write("  );\n")
    out_file.write("end entity;\n\n")
    
    out_file.write("architecture rtl of LUT is\n\n")
    out_file.write(f"  type LUT_t is array (natural range 0 to {N_LUT_line-1}) of integer;\n\n")
    out_file.write("  constant LUT: LUT_t := (\n    ")

    for a in range(N_LUT_line):
        x = round((math.sin(2 * math.pi * a / N_LUT_line)) / lsb)
        
        # 16-bit values go up to 32767, so we need 6 spaces for alignment (including negative sign)
        entry = f"{a:>4} => {int(x):>6}"
        
        if a < (N_LUT_line - 1):
            out_file.write(entry + ", ")
            if (a + 1) % 8 == 0:
                out_file.write("\n    ")
        else:
            out_file.write(entry + "\n")

    out_file.write("  );\n\nbegin\n\n")
    out_file.write(f"  do <= std_logic_vector(to_signed(LUT(to_integer(unsigned(addr))), {N_DATA_OUT}));\n\n")
    out_file.write("end architecture;\n")