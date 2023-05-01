library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity collision is
    port (
        I_VSYNC, I_S_ON, I_P_ON : in std_logic;
        O_COL : out std_logic
    );
end collision;

architecture behaviour of collision is

    signal COL : std_logic;
begin
    checkCollision : process (I_VSYNC) is
    variable counter : std_logic_vector(4 downto 0);
        begin
        if ((I_S_ON = '1') and (I_P_ON = '1') and (counter = (conv_std_logic_vector(0, 5)))) then
            COL <= '1';
            counter := conv_std_logic_vector(25, 5);
        elsif (counter > conv_std_logic_vector(0, 5)) then
            counter := (counter - conv_std_logic_vector(1, 5));
        else
            COL <= '0';
        end if;
    end process;
    O_COL <= COL;
end architecture;