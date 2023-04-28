library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity collision is
    port (
        I_CLK, I_S_ON, I_P_ON : in std_logic;
        O_COL : out std_logic;
    );
end collision;

architecture behaviour of collision is

    signal COL : std_logic;
begin
    check - collision : process (I_CLK) is
    if ((I_S_ON = '1') and (I_P_ON = '1')) then
        COL <= '1';
    end if;
end process
O_COL <= COL;
end architecture;