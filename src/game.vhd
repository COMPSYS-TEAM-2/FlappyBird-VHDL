library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;

entity game is
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;
        I_M_LEFT : in std_logic;
        O_RGB : out std_logic_vector(11 downto 0);
        O_LED : out std_logic
    );
end game;

architecture behavior of game is
    signal S_X_POS : std_logic_vector(10 downto 0);
    signal S_Y_POS : std_logic_vector(10 downto 0);
    signal S_SIZE : std_logic_vector(9 downto 0);
    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;

    signal LF_RANDOM : std_logic_vector(7 downto 0);

    signal C_ON : std_logic;

    signal L_CLK : std_logic := '1';

    signal B_COLOUR : std_logic_vector(11 downto 0) := x"2AC";

begin
    square : entity work.square
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CLICK => I_M_LEFT,
            O_X_POS => S_X_POS,
            O_Y_POS => S_Y_POS,
            O_S_SIZE => S_SIZE,
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    obstacles : entity work.obstacles
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_RANDOM => LF_RANDOM,
            O_RGB => P_RGB,
            O_ON => P_ON,
            O_COLLISION => O_LED
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_V_SYNC,
            I_RVAL => I_M_LEFT,
            O_VAL => LF_RANDOM
        );

    O_RGB <= S_RGB when (S_ON = '1') else
        P_RGB when (P_ON = '1') else
        B_COLOUR;
end architecture;