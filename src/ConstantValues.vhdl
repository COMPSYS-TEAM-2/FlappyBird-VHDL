library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package Constantvalues is
    constant SCREEN_WIDTH : INTEGER := 639;
    constant SCREEN_HEIGHT : INTEGER := 479;
    constant GRAVITY : STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(1, 10);
    constant PLAYER_SIZE : INTEGER := 32;
    constant PIPE_GAP_ONE : STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(195, 10);
    constant PIPE_GAP_TWO : STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(130, 10);
    constant PIPE_WIDTH : INTEGER := 40;
    constant PIPE_ACCELERATION : STD_LOGIC_VECTOR(9 downto 0) := conv_std_logic_vector(1, 10);
    constant MENU_BUTTON_SIZE_X : INTEGER := 160;
    constant MENU_BUTTON_SIZE_Y : INTEGER := 80;
    constant MENU_BUTTON_X : INTEGER := (SCREEN_WIDTH - MENU_BUTTON_SIZE_X) / 2;
    constant MENU_BUTTON_Y : INTEGER := 360;
    constant CLOCK_POWERUP : STD_LOGIC_VECTOR(5 downto 0) := o"45";
    constant SHEILD_POWERUP : STD_LOGIC_VECTOR(5 downto 0) := o"46";
    constant HEART_POWERUP : STD_LOGIC_VECTOR(5 downto 0) := o"47";

end package Constantvalues;