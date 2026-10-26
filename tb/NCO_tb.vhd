library IEEE;
use IEEE.std_logic_1164.all;

entity NCO_tb is
    generic(
        PHASE_W : positive := 32;
        ADDR_W  : positive := 12;
        DATA_W  : positive := 16
    );
end entity;

architecture beh of NCO_tb is

    constant clk_period : time := 8 ns;

    constant PHASE : positive := 32;
    constant ADDR  : positive := 12;
    constant DATA  : positive := 16;

    component NCO
        generic(
            PHASE_W : positive;
            ADDR_W  : positive;
            DATA_W  : positive
        );
        port (
            clk     : in std_logic;
            reset_n : in std_logic;
            fw      : in std_logic_vector(PHASE_W-1 downto 0);

            i_do    : out std_logic_vector(DATA_W-1 downto 0);
            q_do    : out std_logic_vector(DATA_W-1 downto 0)  
        );
    end component;
    
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal testing : boolean := true;

    signal fw_ext : std_logic_vector(PHASE_W-1 downto 0) := (others => '0');
    signal i_do_ext : std_logic_vector(DATA_W-1 downto 0);
    signal q_do_ext : std_logic_vector(DATA_W-1 downto 0);

    begin
        clk <= not clk after clk_period / 2 when testing else '0';

        i_DUT : NCO
            generic map(
                PHASE_W => PHASE,
                ADDR_W => ADDR,
                DATA_W => DATA
            )
            port map(
                clk => clk,
                reset_n => reset_n,
                fw => fw_ext,
                i_do => i_do_ext,
                q_do => q_do_ext
            );
            
        p_STIMULUS : process begin
            wait for 8 ns;
            reset_n <= '1';
            fw_ext <= x"000FF00F";
            wait for 20000 ns; 
            fw_ext <= x"04000000";
            -- reset testing
            wait for 17000 ns;
            reset_n <= '0';
            wait for 10000 ns;
            reset_n <= '1';
            fw_ext <= x"0044FFFF";
            wait for 17000 ns;
            testing <= false;
            wait;
        end process;
end architecture;