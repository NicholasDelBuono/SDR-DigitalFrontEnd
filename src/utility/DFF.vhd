library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
    generic( Nbit : positive := 32 );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        en      : in std_logic;
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0)
    );

end entity;

architecture rtl of DFF is
    signal di_s : std_logic_vector(Nbit-1 downto 0);
    signal do_s : std_logic_vector(Nbit-1 downto 0);
begin

    p_DFF : process(clk, reset_n)
    begin
        if reset_n = '0' then
            do_s <= (others => '0');
        elsif rising_edge(clk) then
            do_s <= di_s;
        end if;
    end process;

    di_s <= di when en = '1' else do_s;
    do <= do_s;
end architecture;