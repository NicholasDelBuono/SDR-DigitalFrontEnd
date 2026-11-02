library IEEE;
use IEEE.std_logic_1164.all;

entity DigitalMixer is
    generic( 
        NCO_W : positive := 16;
        ADC_W : positive := 32;
        OUT_W : positive := 48
    );
    port(
        i_di    : in std_logic_vector(NCO_W-1 downto 0);
        q_di    : in std_logic_vector(NCO_W-1 downto 0);
        adc_di  : in std_logic_vector(ADC_W-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        i_do    : out std_logic_vector(OUT_W-1 downto 0);
        q_do    : out std_logic_vector(OUT_W-1 downto 0)
    );
end entity;

architecture struct of DigitalMixer is
    component MixerBranch is
        generic(
            NCO_W : positive;
            ADC_W : positive;
            OUT_W : positive
        );
        port(
            nco_di  : std_logic_vector(NCO_W-1 downto 0);
            adc_di  : std_logic_vector(ADC_W-1 downto 0);
            clk     : std_logic;
            reset_n : std_logic;
            neg     : std_logic;

            do      : std_logic_vector(OUT_W-1 downto 0)
        );
    end component;

    -- In-phase component
    i_MIX_I : MixerBranch
        generic map(
            NCO_W => NCO_W,
            ADC_W => ADC_W,
            OUT_W => OUT_W
        )
        port map(
            nco_di => i_di,
            adc_di => adc_di,
            clk => clk,
            reset_n => reset_n,
            neg => '0'

            do => i_do
        );

    -- Quadrature component
    i_MIX_Q : MixerBranch
        generic map(
            NCO_W => NCO_W,
            ADC_W => ADC_W,
            OUT_W => OUT_W
        )
        port map(
            nco_di => q_di,
            adc_di => adc_di,
            clk => clk,
            reset_n => reset_n,
            neg => '1'

            do => q_do
        );

end architecture;