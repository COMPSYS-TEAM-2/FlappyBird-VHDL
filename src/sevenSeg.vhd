library IEEE;
use IEEE.std_logic_1164.all;

entity LEVEL_TO_SEVEN_SEG is
    port (
        I_REV_GRAVITY : in STD_LOGIC;
        I_S_PIPE : in STD_LOGIC;
        O_DISPLAY : out STD_LOGIC_VECTOR(6 downto 0)
    );
end entity;

architecture arc1 of LEVEL_TO_SEVEN_SEG is
begin
    O_DISPLAY <= "1001111" when (I_S_PIPE = '0' and I_REV_GRAVITY = '0') else -- 1
        "0010010" when (I_S_PIPE = '0' and I_REV_GRAVITY = '1') else -- 2
        "0000110" when (I_S_PIPE = '1' and I_REV_GRAVITY = '0') else -- 3
        "1001100" when (I_S_PIPE = '1' and I_REV_GRAVITY = '1') else -- 4
        "0000001"; -- 0 

end architecture arc1;