library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_lfsr is
end entity test_lfsr;

architecture test of test_lfsr is

    signal T_CLK : std_logic := '0';
    signal T_RVAL : std_logic := '1';
    signal T_VAL : std_logic_vector(7 downto 0);

    component lfsr is
        port (I_CLK, I_RVAL : in std_logic;
        O_VAL : out std_logic_vector(7 downto 0));
    end component lfsr;

begin
DUT : lfsr port map (T_CLK, T_RVAL, T_VAL);

T_CLK <= not T_CLK after 5 ns;
T_RVAL <= not T_RVAL after 200 ns;

end architecture test;