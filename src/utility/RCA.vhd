library IEEE;
use IEEE.std_logic_1164.all;

entity RCA is
    generic( Nbit : positive := 32 );
    port (
        a    : in std_logic_vector(Nbit-1 downto 0);
        b    : in std_logic_vector(Nbit-1 downto 0);
        cin  : in std_logic;
        
        s    : out std_logic_vector(Nbit-1 downto 0);
        cout : out std_logic
    );
end entity;

architecture beh of RCA is
begin
    p_RCA: process(a, b, cin)
        variable c : std_logic;
    begin
        c := cin;

        for i in s'reverse_range loop
            s(i) <= a(i) xor b(i) xor c;
            c := (a(i) and b(i)) or (a(i) and c) or (b(i) and c);
        end loop;

        cout <= c;
    
    end process;
end architecture;