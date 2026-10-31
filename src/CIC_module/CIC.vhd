library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CIC is
    generic(
        Nbit   : positive := 18;
        Nstage : positive := 3;
        R      : positive := 8
    );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0);
        dav     : out std_logic
    );
end entity;

architecture struct of CIC is
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
    component Counter is
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic
        );
    end component;
    component Accumulator is
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;
    component Comb_Filter is
        generic( Nbit : positive );
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            en      : in std_logic;
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic_vector(Nbit-1 downto 0)
        );
    end component;

    function clog2(n : positive) return natural is
        variable bits : natural  := 0;
        variable v    : positive := 1;
    begin
        while v < n loop
            v := v * 2;
            bits := bits + 1;
        end loop;
        return bits;
    end function;
    
    function counter_w(n : positive) return positive is
    begin
        if n < 2 then return 1; else return clog2(n); end if;
    end function;

    constant W  : positive := Nbit + Nstage * clog2(R);   -- internal width (M = 1)
    constant CW : positive := counter_w(R);               -- counter width

    type array_of_ds is array (0 to Nstage) of std_logic_vector(W-1 downto 0);
    signal d_Acc  : array_of_ds;
    signal d_Comb : array_of_ds;

    signal en_int  : std_logic;
    signal en_vec  : std_logic_vector(0 downto 0);
    signal dav_vec : std_logic_vector(0 downto 0);

begin

    -- Extention
    d_Acc(0)(Nbit-1 downto 0) <= di;
    d_Acc(0)(W-1 downto Nbit) <= (others => di(Nbit-1));

    g_Accumulator : for i in 1 to Nstage generate
        i_Accumulator : Accumulator
            generic map( Nbit => W )
            port map(
                di      => d_Acc(i-1),
                clk     => clk,
                reset_n => reset_n,

                do      => d_Acc(i)
            );
    end generate;

    d_Comb(0) <= d_Acc(Nstage);

    g_Comb : for i in 1 to Nstage generate
        i_Comb : Comb_Filter
            generic map( Nbit => W )
            port map(
                di      => d_Comb(i-1),
                en      => en_int,
                clk     => clk,
                reset_n => reset_n,

                do      => d_Comb(i)
            );
    end generate;

    i_Counter : Counter
        generic map( Nbit => CW )
        port map(
            di => std_logic_vector(to_unsigned(R-1, CW)),
            clk => clk,
            reset_n => reset_n,

            do => en_int
        );

    -- Truncation
    do <= d_Comb(Nstage)(W-1 downto W-Nbit);

    en_vec(0) <= en_int;

    i_DFF : DFF
        generic map( Nbit => 1 )
        port map(
            di => en_vec,
            en => '1',
            clk => clk,
            reset_n => reset_n,

            do => dav_vec
        );

    dav <= dav_vec(0);

end architecture;