library IEEE;
use IEEE.std_logic_1164.all;

-- NCO: Numerically Controlled Oscillator, to be implemented

entity NCO is
    generic( 
        Nbit : positive := 32;                   -- Tuning resolution
        Pbit : positive := 10;                  -- # of bits after truncation for the ROM address
        Wbit : positive := 12                   -- width of the sinusoids amplitude output 
        );
    port(
        clk      : in std_logic;
        reset_n  : in std_logic;
        tuning_M : in std_logic_vector(Nbit-1 downto 0);

        cos_out  : out std_logic_vector(Wbit-1 downto 0);
        sin_out  : out std_logic_vector(Wbit-1 downto 0)
    );
end entity;
    
architecture struct of NCO is
    component Phase_Accumulator
        generic( Nbit : positive );
            port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;
begin

-- [...]

end architecture;