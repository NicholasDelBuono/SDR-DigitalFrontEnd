library IEEE;
use IEEE.std_logic_1164.all;

-- A phase accumulator

entity Phase_Accumulator is
    generic( Nbit : positive := 32 );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0)
    );
end entity;

architecture struct of Phase_Accumulator is

    component DFF
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            en      : in std_logic;
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;
    component RippleCarryAdder
        generic( Nbit : positive );
        port(
            a    : in std_logic_vector(Nbit-1 downto 0);
            b    : in std_logic_vector(Nbit-1 downto 0);
            cin  : in std_logic;
        
            s    : out std_logic_vector(Nbit-1 downto 0);
            cout : out std_logic
        );
    end component;

    signal s_int  : std_logic_vector(Nbit-1 downto 0);
    signal do_int : std_logic_vector(Nbit-1 downto 0);

begin
    i_RCA : RippleCarryAdder
        generic map(
            Nbit => Nbit
        )
        port map(
            a => di,
            b => do_int,
            cin => '0',
            
            s => s_int,
            cout => open
        );
    i_DFF : DFF
        generic map(
            Nbit => Nbit
        )
        port map(
            di => s_int,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => do_int
        );

    do <= do_int;
end architecture;