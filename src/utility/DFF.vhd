library IEEE;
use IEEE.std_logic_1164.all;

-- A Data Flip-Flop

entity DFF is
    generic( Nbit : positive := 32 );
    port(
        di     : in std_logic_vector(Nbit-1 downto 0);
        en     : in std_logic;
        clk    : in std_logic;
        reset_n : in std_logic;

        do     : out std_logic_vector(Nbit-1 downto 0)
    );

end entity;

architecture rtl of DFF_N is
    signal di_s : std_logic_vector(Nbit-1 downto 0);
    signal do_s : std_logic_vector(Nbit-1 downto 0);
begin
    -- Simulating the DFF
    p_DFF_N: process(clk, reset_n)
    begin
        if reset_n = '0' then
            do_s <= (others => '0');
        elsif rising_edge(clk) then
            do_s <= di_s;
        end if;
    end process;

    -- Simulating the MUX
    di_s <= di when en = '1' else do_s;
    
    -- Generic
    do <= do_s;
end architecture;

-- Correct i guess, but by mixing the interal component in a 
-- single logic implementation

-- architecture rtl of DFF_N is
-- begin
--     p_DFF_N: process(clk, reset_n)
--     begin
--         if reset_n = '0' then
--             do <= (others => '0');
--         elsif rising_edge(clk) then
--             if en = '1' then
--                 do <= di;
--             end if;
--         end if;
--     end process;
-- end architecture;