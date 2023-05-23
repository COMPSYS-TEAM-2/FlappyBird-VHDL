library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;
use work.Constantvalues.all;
use work.RGBValues.all;

entity ground is
    port (
        I_V_SYNC : in std_logic;
        I_ENABLE : in std_logic;
        I_PIXEL : in T_RECT;
        I_BIRD : in T_RECT;
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_COLLISION : out std_logic
    );
end ground;

architecture behavior of ground is
begin
    O_ON <= '1' when (I_PIXEL.Y >= conv_std_logic_vector(SCREEN_HEIGHT - GROUND_HEIGHT - GRASS_HEIGHT, 10)) else
        '0';
    O_COLLISION <= '1' when (I_BIRD.Y + I_BIRD.HEIGHT >= conv_std_logic_vector(SCREEN_HEIGHT - GROUND_HEIGHT - GRASS_HEIGHT, 10)) else
        '0';

    O_RGB <= GROUND_RGB when I_PIXEL.Y >= conv_std_logic_vector(SCREEN_HEIGHT - GROUND_HEIGHT, 10) else
        GRASS_RGB;
end architecture;