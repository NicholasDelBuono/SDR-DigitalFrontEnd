library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MixerBranch is
    generic(
        NCO_W : positive := 16;
        ADC_W : positive := 14;
        OUT_W : positive := 18
    );
    port(
        nco_di  : in std_logic_vector(NCO_W-1 downto 0);
        adc_di  : in std_logic_vector(ADC_W-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;
        neg     : in std_logic;

        do      : out std_logic_vector(OUT_W-1 downto 0)
    );
end entity;

architecture struct of MixerBranch is
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

    constant P_W : positive := ADC_W + NCO_W;
    constant LSB : natural := P_W - OUT_W - 1;

    signal mul_adc : std_logic_vector(ADC_W-1 downto 0);
    signal mul_nco : std_logic_vector(NCO_W-1 downto 0);
    
    signal mul_s : signed(P_W-1 downto 0);
    signal mul_out : std_logic_vector(P_W-1 downto 0);

    signal inc_out : std_logic_vector(OUT_W-1 downto 0);

begin
    i_DFF_adc : DFF
        generic map( Nbit => ADC_W )
        port map(
            di => adc_di,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => mul_adc
        );
    i_DFF_nco : DFF
        generic map( Nbit => NCO_W )
        port map(
            di => nco_di,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => mul_nco
        );

    -- For optimization purposes

    mul_s <= -(signed(mul_adc) * signed(mul_nco)) when neg = '1'
            else signed(mul_adc) * signed(mul_nco);

    i_DFF_prod : DFF
        generic map( Nbit => P_W )
        port map(
            di => std_logic_vector(mul_s),
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => mul_out
        );

    i_INC : INC
        generic map( Nbit => OUT_W )
        port map(
            a => mul_out(P_W-2 downto LSB),
            cin => mul_out(LSB-1),
            s => inc_out,
            cout => open
        );

    i_DFF_out : DFF
        generic map( Nbit => OUT_W )
        port map(
            di => inc_out,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => do
        );

end architecture;