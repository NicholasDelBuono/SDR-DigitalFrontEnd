library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RCA_tb is
    generic(
            Nbit : positive := 8
    );
end entity;

architecture beh of RCA_tb is

    constant clk_period : time := 100 ns;
    constant N          : positive := 8;

    component RCA_tb
        generic( Nbit : positive );
        port(
            a    :      in std_logic_vector(Nbit-1 downto 0);
            b    :      in std_logic_vector(Nbit-1 downto 0);
            cin  :      in std_logic;

            s    :      out std_logic_vector(Nbit-1 downto 0);
            cout :      out std_logic
        );
    end component;

    signal clk      : std_logic := '0';

    signal a_ext    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal b_ext    : std_logic_vector(N-1 downto 0) := (others => '0');
    signal cin_ext  : std_logic := '0';
    
    signal s_ext    : std_logic_vector(N-1 downto 0);
    signal cout_ext : std_logic;
    
    signal testing  : boolean := true;


    begin
        clk <= not clk after clk_period / 2 when testing else '0';

        i_DUT : RCA
            generic map(
                Nbit => N
            )
            port map(
                a => a_ext,
                b => b_ext,
                cin => cin_ext,
                s => s_ext,
                cout => cout_ext
            );
        
        p_STIMULUS : process begin
            a_ext <= (others => '0');
            b_ext <= (others => '0');
            cin_ext <= '0';
            wait for 200 ns;
            a_ext <= "00000110";
            b_ext <= "00100110";
            cin_ext <= '0';
            wait until rising_edge(clk);
            a_ext <= x"76";                                 -- 0111_0110
            b_ext <= x"14";                                 -- 0001_0100
            cin_ext <= '1';
            wait until rising_edge(clk);
            a_ext <= (others => '0');
            b_ext <= (others => '0');
            cin_ext <= '0';
            wait for 1008 ns;
            a_ext <= x"FF";
            b_ext <= x"FF";
            cin_ext <= '0';
            wait for 500 ns;
            testing <= false;
            wait until rising_edge(clk);
        end process;
end architecture;
