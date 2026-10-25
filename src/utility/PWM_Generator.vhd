library IEEE;
use IEEE.std_logic_1164.all;

-- A Power Width Modulator

entity PWM is
    generic( Nbit : positive := 32 );
    port(
        d_cycle : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic
    );
end entity;

architecture struct of PWM is
    component Phase_Accumulator
        generic( Nbit : positive );
            port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    component Comparator
        generic( Nbit : positive );
        port(
            a : in std_logic_vector(Nbit-1 downto 0);
            b : in std_logic_vector(Nbit-1 downto 0);

            e : out std_logic;
            h : out std_logic
        );
    end component;

    signal count_s : std_logic_vector(Nbit-1 downto 0);
    signal e_s : std_logic;
    signal h_s : std_logic;
begin
    i_CNT : Phase_Accumulator
        generic map(
            Nbit => Nbit
        )
        port map(
            di => (0 => '1', others => '0'),
            clk => clk,
            reset_n => reset_n,

            do => count_s
        );

    i_CMP : Comparator
        generic map(
            Nbit => Nbit
        )
        port map(
            a => count_s,
            b => d_cycle,

            e => e_s,
            h => h_s
        );

    do <= e_s nor h_s;
end architecture;