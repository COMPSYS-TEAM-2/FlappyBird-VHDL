library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;
use work.Rectangle.all;
use work.constantvalues.all;
use work.RGBValues.all;

entity menu is
    port (
        I_ON : in std_logic;
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;

        I_M_LEFT : in std_logic;
        I_CURSOR : in T_RECT;

        O_RGB : out std_logic_vector(11 downto 0);
        O_BUTTON : out std_logic_vector(1 downto 0)
    );
end menu;

architecture behavior of menu is
    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;
    signal P_CLICK : std_logic;

    signal T_RGB : std_logic_vector(11 downto 0);
    signal T_ON : std_logic;
    signal T_CLICK : std_logic;

    signal L_MOUSE_ON : std_logic;
begin
    spriteMouse : entity work.sprite
        port map(
            I_CLK => I_CLK,
            I_X => I_CURSOR.X,
            I_Y => I_CURSOR.Y,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X,
            I_INDEX => o"52",
            O_ON => L_MOUSE_ON
        );

    playbutton : entity work.menubutton
        generic map(
            CreateRect(MENU_BUTTON_X, MENU_BUTTON_PLAY_Y, MENU_BUTTON_SIZE_X, MENU_BUTTON_SIZE_Y),
            MENU_PLAY_BUTTON_RGB
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => P_RGB,
            O_ON => P_ON,
            O_CLICK => P_CLICK
        );

    trainbutton : entity work.menubutton
        generic map(
            CreateRect(MENU_BUTTON_X, MENU_BUTTON_TRAIN_Y, MENU_BUTTON_SIZE_X, MENU_BUTTON_SIZE_Y),
            MENU_TRAIN_BUTTON_RGB
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => T_RGB,
            O_ON => T_ON,
            O_CLICK => T_CLICK
        );

    O_RGB <= MOUSE_RGB when L_MOUSE_ON = '1' else
        T_RGB when T_ON = '1' else
        P_RGB when P_ON = '1' else
        MENU_BACKGROUND_RGB;

    O_BUTTON <= "00" when I_ON = '0' else
        "01" when P_CLICK = '1' else
        "10" when T_CLICK = '1' else
        "00";
end architecture;