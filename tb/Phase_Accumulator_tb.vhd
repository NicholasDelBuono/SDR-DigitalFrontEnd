library IEEE;
use IEEE.std_logic_1164.all;

entity Phase_Accumulator_tb is
    generic(
        Nbit : positive := 8
    );
end entity;

architecture beh of Phase_Accumulator_tb is

    constant clk_period : time := 100 ns;
    constant N          : positive := 8;

    component Phase_Accumulator
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal testing : boolean := true;

    signal di_ext : std_logic_vector(N-1 downto 0) := (others => '0');
    signal do_ext : std_logic_vector(N-1 downto 0);                         -- U

    begin
        clk <= not clk after clk_period / 2 when testing else '0';

        i_DUT : Phase_Accumulator
            generic map(
                Nbit => N
            )
            port map(
                di => di_ext,
                do => do_ext,
                clk => clk,
                reset_n => reset_n
            );
        p_STIMULUS : process begin
            -- Asynchronous reset
            wait for 20 ns;
            reset_n <= '1';

            -- testing
            wait for 200 ns;
            di_ext <= x"1F";                                            -- 0001_1111
            wait until rising_edge(clk);

            di_ext <= x"01";                                            -- 0000_0001
            for i in 1 to 10 loop
                wait until rising_edge(clk);
            end loop;
            
            wait for 10 ns;
            testing <= false;
            wait;

        end process;
end architecture;