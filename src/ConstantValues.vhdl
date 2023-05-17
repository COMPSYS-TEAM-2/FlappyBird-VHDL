library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package Constantvalues is
    constant SCREEN_WIDTH : std_logic_vector(9 downto 0) := conv_std_logic_vector(640, 10);
    constant SCREEN_HEIGHT : std_logic_vector(9 downto 0) := conv_std_logic_vector(480, 10);
    constant GRAVITY : std_logic_vector(9 downto 0) := conv_std_logic_vector(1, 10);
    constant PLAYER_SIZE : integer := 32;
    constant PIPE_GAP : std_logic_vector(9 downto 0) := conv_std_logic_vector(195, 10);
    constant PIPE_WIDTH : integer := 40;
    constant PIPE_ACCELERATION : std_logic_vector(9 downto 0) := conv_std_logic_vector(1, 10);
    constant MENU_BUTTON_SIZE_X : integer := 160;
    constant MENU_BUTTON_SIZE_Y : integer := 80;
    constant MENU_BUTTON_X : integer := (639 - MENU_BUTTON_SIZE_X) / 2;
    constant MENU_BUTTON_PLAY_Y : integer := (479 / 2) - MENU_BUTTON_SIZE_Y - 10;
    constant MENU_BUTTON_TRAIN_Y : integer := (479 / 2) + 10;

end package Constantvalues;