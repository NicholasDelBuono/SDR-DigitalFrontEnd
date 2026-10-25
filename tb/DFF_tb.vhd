library IEEE;
use IEEE.std_logic_1164.all;

entity DFF_tb is
    generic(
        Nbit : positive := 8
    );
end entity;

architecture beh of DFF_N_tb is

    constant clk_period : time := 100 ns;
    constant N          : positive := 8;

    component DFF
        generic(
            Nbit : positive
        );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            en      : in std_logic;
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal testing  : boolean := true;
    signal reset_n : std_logic := '0';

    signal di_ext : std_logic_vector(N-1 downto 0) := (others => '0');
    signal en_ext : std_logic := '0';
    signal do_ext : std_logic_vector(N-1 downto 0);                      -- U

    begin
        clk <= not clk after clk_period / 2 when testing else '0';

        i_DUT : DFF
            generic map(
                Nbit => N
            )
            port map(
                di => di_ext,
                en => en_ext,
                do => do_ext,
                clk => clk,
                reset_n => reset_n
            );
        
        p_STIMULUS : process begin
            -- reset values
            di_ext <= (others => '0');
            en_ext <= '0';
            -- Asynchronous Reset
            wait for 20 ns;
            reset_n <= '1';
            
            -- starting the tests
            wait for 200 ns;
            di_ext <= x"21";                                -- 0010_0001
            en_ext <= '0';
            wait until rising_edge(clk);
            di_ext <= x"21";                                -- 0010_0001
            en_ext <= '1';
            wait until rising_edge(clk);
            di_ext <= x"89";                                -- 1000_1001
            en_ext <= '1';
            wait until rising_edge(clk);
            di_ext <= x"01";                                -- 0000_0001
            en_ext <= '0';
            wait until rising_edge(clk);
            di_ext <= x"FF";                                -- 1111_1111
            en_ext <= '0';
            wait until rising_edge(clk);
            di_ext <= x"00";                                -- 0000_0000
            en_ext <= '1';
            -- it should end in 00
            wait until rising_edge(clk);
            di_ext <= x"55";                                -- 0101_0101
            en_ext <= '0';
            wait for 408 ns;
            di_ext <= x"FF";                                -- 1111_1111
            en_ext <= '0';
            wait for 500 ns;
            testing <= false;
            wait;
        end process;
end architecture;