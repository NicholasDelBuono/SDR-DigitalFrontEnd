library IEEE;
use IEEE.std_logic_1164.all;

entity Counter is
    generic( Nbit : positive := 32 );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic
    );
end entity;

architecture struct of Counter is
    component Comparator is
        generic( Nbit : positive := 32 );
        port(
            a : in std_logic_vector(Nbit-1 downto 0);
            b : in std_logic_vector(Nbit-1 downto 0);

            h : out std_logic;                                -- a > b ? 1 : 0
            e : out std_logic                                 -- a = b ? 1 : 0
        );
    end component;
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
    component INC is
        generic( Nbit : positive );
        port(
            a    : in std_logic_vector(Nbit-1 downto 0);
            cin  : in std_logic;

            s    : out std_logic_vector(Nbit-1 downto 0);
            cout : out std_logic
        );
    end component;

    signal dff_in  : std_logic_vector(Nbit-1 downto 0);

    signal dff_out : std_logic_vector(Nbit-1 downto 0);
    signal inc_out : std_logic_vector(Nbit-1 downto 0);

    signal do_int : std_logic;

begin
    i_INC : INC
        generic map( Nbit => Nbit )
        port map(
            a => dff_out,
            cin => '1',
            s => inc_out,
            cout => open
        );

    -- A bitwise and component
    g_CLR : for i in 0 to Nbit-1 generate
        dff_in(i) <= inc_out(i) and (not do_int);
    end generate;

    i_DFF : DFF
        generic map( Nbit => Nbit )
        port map(
            di => dff_in,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => dff_out
        );
    i_Comparator : Comparator
        generic map( Nbit => Nbit )
        port map(
            a => dff_out,
            b => di,

            h => open,
            e => do_int
        );

    do <= do_int;

end architecture;