library IEEE;
use IEEE.std_logic_1164.all;

entity FIFO_tb is
    generic(
        Nbit : positive := 8;
        Mnum : positive := 8
    );
end entity;

architecture beh of FIFO_tb is
    constant clk_period : time := 100 ns;
    constant N : positive := 8;
    constant M : positive := 8;

    component FIFO
        generic(
            Nbit : positive;
            Mnum : positive
        );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal testing : boolean := true;

    signal di_ext : std_logic_vector(N-1 downto 0) := (others => '0');
    signal do_ext : std_logic_vector(N-1 downto 0);

    begin
        clk <= not clk after clk_period / 2 when testing else '0';

        i_DUT : FIFO
            generic map(
                Nbit => N,
                Mnum => M
            )
            port map(
                di => di_ext,
                do => do_ext,
                clk => clk,
                reset_n => reset_n
            );
        p_STIMULUS : process begin
            wait for 20 ns;
            reset_n <= '1';

            wait for 200 ns;
            di_ext <= x"FF";                                -- 1111_1111
            wait until rising_edge(clk);
            di_ext <= x"01";                                -- 0000_0001
            wait until rising_edge(clk);
            di_ext <= x"00";                                -- 0000_0000
            wait for 910 ns;
            testing <= false;
            wait;
        end process;
end architecture;
            