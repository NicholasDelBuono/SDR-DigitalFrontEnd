library IEEE;
use IEEE.std_logic_1164.all;

entity Comparator is
    generic( Nbit : positive := 32 );
    port(
        a : in std_logic_vector(Nbit-1 downto 0);
        b : in std_logic_vector(Nbit-1 downto 0);

        h : out std_logic;                                -- a > b ? 1 : 0
        e : out std_logic                                 -- a = b ? 1 : 0
    );
end entity;

architecture rtl of Comparator is
    component RCA is
        generic( Nbit : positive );
        port(
            a    : in std_logic_vector(Nbit-1 downto 0);
            b    : in std_logic_vector(Nbit-1 downto 0);
            cin  : in std_logic;
        
            s    : out std_logic_vector(Nbit-1 downto 0);
            cout : out std_logic
        );
    end component;

    signal e_int    : std_logic;
    signal cout_int : std_logic;
    signal s_int    : std_logic_vector(Nbit-1 downto 0);
    signal b_inv    : std_logic_vector(Nbit-1 downto 0);

begin
    b_inv <= not b;

    i_RCA : RCA
        generic map( Nbit => Nbit )
        port map(
            a => a,
            b => b_inv,
            cin => '1',
            
            s => s_int,
            cout => cout_int
        );

    e_int <= '1' when s_int = (others => '0') else '0';
    
    h <= cout_int and (not e_int);
    e <= e_int;
end architecture;