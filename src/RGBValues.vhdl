library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package RGBValues is
    constant PIPE_RGB_ONE : std_logic_vector(11 downto 0) := x"5E2";
	 constant PIPE_RGB_TWO : std_logic_vector(11 downto 0) := x"80F";
    constant BACKGROUND_RGB : std_logic_vector(11 downto 0) := x"2AC";
    constant MOUSE_RGB : std_logic_vector(11 downto 0) := x"000";
    constant MENU_BACKGROUND_RGB : std_logic_vector(11 downto 0) := x"EA4";
    constant MENU_BUTTON_RGB : std_logic_vector(11 downto 0) := x"C82";
    constant MENU_BUTTON_ONCLICK_RGB : std_logic_vector(11 downto 0) := x"A71";
    constant HEART_SPRITE_RGB : std_logic_vector(11 downto 0) := x"F00";
    constant CLOCK_SPRITE_RGB : std_logic_vector(11 downto 0) := x"000";
    constant SHEILD_SPRITE_RGB : std_logic_vector(11 downto 0) := x"00F";
    constant BIRD_RGB : std_logic_vector(11 downto 0) := x"93A";
    constant BIRD_EYE_RGB : std_logic_vector(11 downto 0) := x"000";
    constant BIRD_BEAK_RGB : std_logic_vector(11 downto 0) := x"FF0";
    constant GROUND_RGB : std_logic_vector(11 downto 0) := x"752";
    constant GRASS_RGB : std_logic_vector(11 downto 0) := x"8d5";

end package RGBValues;