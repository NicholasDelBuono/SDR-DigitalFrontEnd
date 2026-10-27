library IEEE;
use IEEE.std_logic_1164.all;

entity INC is
    generic( Nbit : positive := 32 );
    port(
        a    : in std_logic_vector(Nbit-1 downto 0);

        s    : out std_logic_vector(Nbit-1 downto 0);
        cout : out std_logic;
    );
end entity;

architecture rtl of INC is
begin
    p_INC : process(a)
        variable c : std_logic;
    begin
        c := '1';

        for i in s'reverse_range loop
            s(i) <= a(i) xor c;
            c    := a(i) and c;
        end loop;

        cout <= c;
    end process;
end architecture;