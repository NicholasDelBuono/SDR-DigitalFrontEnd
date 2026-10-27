library IEEE;
use IEEE.std_logic_1164.all;

entity FIFO is
    generic(
        Nbit : positive := 32;
        Mnum : positive := 256
    );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0)
    );
end entity;

architecture structural of FIFO is
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

    type array_of_ds is array (1 to Mnum-1) of std_logic_vector(Nbit-1 downto 0);
    signal d_s : array_of_ds;

begin
    g_DFF : for i in 1 to Mnum generate
        g_FIRST : if i = 1 generate
            i_DFF : DFF
                generic map( Nbit => Nbit )
                port map(
                    di => di,
                    en => '1',
                    clk => clk,
                    reset_n => reset_n,
                    do => d_s(i)
                );
        end generate;

        g_INTERNAL : if i > 1 and i < Mnum generate
            i_DFF : DFF
                generic map( Nbit => Nbit )
                port map(
                    di => d_s(i-1),
                    en => '1',
                    clk => clk,
                    reset_n => reset_n,
                    do => d_s(i)
                );
        end generate;

        g_LAST : if i = Mnum generate
            i_DFF : DFF
                generic map( Nbit => Nbit )
                port map(
                    di => d_s(i-1),
                    en => '1',
                    clk => clk,
                    reset_n => reset_n,
                    do => do
                );
        end generate;
    end generate;
end architecture;