library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr is
    port (
        I_CLK, I_RVAL : in std_logic;
        O_VAL : out std_logic_vector(7 downto 0)
    );
end lfsr;

architecture rtl of lfsr is
    signal L_VAL0 : std_logic := '0';
    signal L_VAL1 : std_logic := '1';
    signal L_VAL2 : std_logic := '0';
    signal L_VAL3 : std_logic := '1';
    signal L_VAL4 : std_logic := '0';
    signal L_VAL5 : std_logic := '0';
    signal L_VAL6 : std_logic := '1';
    signal L_VAL7 : std_logic := '0';
begin
    Get_value : process (I_CLK)
    begin
        if rising_edge(I_CLK) then
            L_VAL0 <= L_VAL7 xor I_RVAL;
            L_VAL1 <= L_VAL0;
            L_VAL2 <= L_VAL1 xor L_VAL7;
            L_VAL3 <= L_VAL2;
            L_VAL4 <= L_VAL3 xor L_VAL7;
            L_VAL5 <= L_VAL4 xor L_VAL7;
            L_VAL6 <= L_VAL5;
            L_VAL7 <= L_VAL6;
        end if;
    end process Get_value;

    O_VAL <= L_VAL0 & L_VAL1 & L_VAL2 & L_VAL3 & L_VAL4 & L_VAL5 & L_VAL6 & L_VAL7;

end architecture;