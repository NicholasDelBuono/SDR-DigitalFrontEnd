library IEEE;
use IEEE.std_logic_1164.all;

entity NCO is
    generic(
        PHASE_W : positive := 32;                   -- Full phase accumulator width
        ADDR_W  : positive := 12;                   -- Truncated width for the LUT
        DATA_W  : positive := 16                    -- Amplitude bit width (In-Phase & Quadrature)
    );
    port (
        clk     : in std_logic;
        reset_n : in std_logic;
        fw      : in std_logic_vector(PHASE_W-1 downto 0);

        i_do    : out std_logic_vector(DATA_W-1 downto 0);          -- Cosine wave
        q_do    : out std_logic_vector(DATA_W-1 downto 0)           -- Sine wave
    );
end entity;

architecture struct of NCO is
    component Accumulator is
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;
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
    component LUT is
        port(
            addr : in  std_logic_vector(ADDR_W-1 downto 0);
            do   : out std_logic_vector(DATA_W-1 downto 0)
        );
    end component;

    signal phase_out : std_logic_vector(PHASE_W-1 downto 0);


    signal lut_do_q : std_logic_vector(DATA_W-1 downto 0);
    signal lut_do_i : std_logic_vector(DATA_W-1 downto 0);

    signal addr_q  : std_logic_vector(ADDR_W-1 downto 0);
    signal addr_i  : std_logic_vector(ADDR_W-1 downto 0);

begin
    addr_q <= phase_out(PHASE_W-1 downto PHASE_W - ADDR_W);             -- Quadrature sine

    addr_i(ADDR_W-3 downto 0) <= addr_q(ADDR_W-3 downto 0);             -- In-phase cosine
    addr_i(ADDR_W-2)          <= not addr_q(ADDR_W-2);
    addr_i(ADDR_W-1)          <= addr_q(ADDR_W-1) xor addr_q(ADDR_W-2);      

    -- Vivado's syntetizer should collapse the two LUTs in a single ROM, so no hardware is wasted here

    i_ACC : Accumulator
        generic map( Nbit => PHASE_W )
        port map(
            di => fw,
            clk => clk,
            reset_n => reset_n,

            do => phase_out
        );

    -- In-Phase components

    i_LUT_I : LUT
        port map(
            addr => addr_i,

            do => lut_do_i
        );
    i_DFF_I : DFF
        generic map( Nbit => DATA_W )
        port map(
            di => lut_do_i,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => i_do
        );

    -- Quadrature components

    i_LUT_Q : LUT
        port map(
            addr => addr_q,

            do => lut_do_q
        );
    i_DFF_Q : DFF
        generic map( Nbit => DATA_W )
        port map(
            di => lut_do_q,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => q_do
        );

end architecture;