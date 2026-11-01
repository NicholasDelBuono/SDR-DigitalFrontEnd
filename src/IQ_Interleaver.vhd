library IEEE;
use IEEE.std_logic_1164.all;

entity IQ_Interleaver is
    generic( 
        Nbit : positive := 18
    );
    port(
        i_di    : in std_logic_vector(Nbit-1 downto 0);
        q_di    : in std_logic_vector(Nbit-1 downto 0);
        dav_di  : in std_logic;
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0);
        dav_do  : out std_logic
    );
end entity;

architecture struct of IQ_Interleaver is
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
    component DelayLine is
        generic( 
            Nbit   : positive;
            Nstage : positive 
        );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            en      : in std_logic;
            clk     : in std_logic;
            reset_n : in std_logic;

            q       : out std_logic_vector(Nstage*Nbit-1 downto 0)
        );
    end component;

    signal i_r : std_logic_vector(Nbit-1 downto 0);
    signal q_r : std_logic_vector(Nbit-1 downto 0);

    signal dav_v : std_logic_vector(0 downto 0); 
    signal d_q : std_logic_vector(1 downto 0);

begin
    dav_v(0) <= dav_di;

    i_DFF_I : DFF
        generic map( Nbit => Nbit )
        port map(
            di => i_di,
            en => dav_di,
            clk => clk,
            reset_n => reset_n,

            do => i_r
        );
    i_DFF_Q : DFF
        generic map( Nbit => Nbit )
        port map(
            di => q_di,
            en => dav_di,
            clk => clk,
            reset_n => reset_n,

            do => q_r
        );
        
    i_DelayLine : DelayLine
        generic map( Nbit => 1, Nstage => 2 )
        port map(
            di => dav_v,
            en => '1',
            clk => clk,
            reset_n => reset_n,
            q => d_q
        );

    do <= q_r when d_q(1) = '1' else i_r;

    dav_do <= d_q(0) or d_q(1);

end architecture;