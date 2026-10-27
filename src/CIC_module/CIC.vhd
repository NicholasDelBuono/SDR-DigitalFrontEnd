library IEEE;
use IEEE.std_logic_1164.all;

entity CIC is
    generic(
        Nbit : positive := 32;
        Mnum : positive := 3
    );
    port(
        di      : in std_logic_vector(Nbit-1 downto 0);
        clk     : in std_logic;
        reset_n : in std_logic;

        do      : out std_logic_vector(Nbit-1 downto 0);
        dav     : out std_logic;
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
        generic( Nbit : positive );                             -- Nbit?
        port(
            di      : in std_logic_vector(Nbit-1 downto 0);
            clk     : in std_logic;
            reset_n : in std_logic;

            do      : out std_logic
        );
    end component;

    -- ...

end architecture;