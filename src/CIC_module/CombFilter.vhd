library IEEE;
use IEEE.std_logic_1164.all;

entity CombFilter is
    generic( Nbit : positive := 32 );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        en      : in std_logic;
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0)
    );
end entity;

architecture struct of CombFilter is
    component DFF is
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            en      : in std_logic;
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;
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

    signal s_int : std_logic_vector(Nbit-1 downto 0);
    signal dff_o : std_logic_vector(Nbit-1 downto 0);
    signal x_inv : std_logic_vector(Nbit-1 downto 0);

begin
    x_inv <= not dff_o;

    i_DFF_in : DFF
        generic map ( Nbit => Nbit )
        port map(
            di => di,
            en => en,
            clk => clk,
            reset_n => reset_n,

            do => dff_o
        );
    i_RCA : RCA
        generic map ( Nbit => Nbit )
        port map(
            a => di,
            b => x_inv,
            cin => '1',

            cout => open,
            s => s_int
        );
    i_DFF_out : DFF
        generic map ( Nbit => Nbit )
        port map(
            di => s_int,
            en => en,
            clk => clk,
            reset_n => reset_n,

            do => do
        );
end architecture;