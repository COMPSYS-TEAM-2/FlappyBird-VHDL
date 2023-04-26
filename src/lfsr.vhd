library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr is
    port (
        I_CLK : in std_logic;
        I_RESET : in std_logic;
        O_VAL : out std_logic;
        );
end lfsr;

architecture rtl of lfsr is

begin
    Get_value : process (I_CLK)
        variable L_OUT : std_logic;
        variable L_VAL0 : std_logic := '0';
        variable L_VAL1 : std_logic := '1';
        variable L_VAL2 : std_logic := '0';
        variable L_VAL3 : std_logic := '1';
        variable L_VAL4 : std_logic := '0';
        variable L_VAL5 : std_logic := '1';
        variable L_VAL6 : std_logic := '0';
        variable L_VAL7 : std_logic := '1';
        variable L_VAL8 : std_logic := '0';
        variable L_VAL9 : std_logic := '1';
    begin
        L_OUT := L_VAL9;
        L_VAL0 := L_VAL9 xor O_VAL;
        L_VAL1 := L_VAL0;
        L_VAL2 := L_VAL1 xor O_VAL;
        L_VAL3 := L_VAL2;
        L_VAL4 := L_VAL3;
        L_VAL5 := L_VAL4 xor O_VAL;
        L_VAL6 := L_VAL5;
        L_VAL7 := L_VAL6 xor O_VAL;
        L_VAL8 := L_VAL7;
        L_VAL9 := L_VAL8;
    end process Get_value; 
    O_VAL <= L_OUT;

end architecture;