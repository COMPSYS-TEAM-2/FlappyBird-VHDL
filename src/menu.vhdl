library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;
use work.Rectangle.all;
entity menu is
    port (
        I_ON : in std_logic;

        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;

        I_M_LEFT : in std_logic;
        I_CURSOR : in T_RECT;

        O_RGB : out std_logic_vector(11 downto 0)
    );
end menu;

architecture behavior of menu is
    constant size_x : integer := 80;
    constant size_y : integer := 40;
    constant x : integer := (639 - size_x) / 2;
    constant y : integer := (479 - size_y) / 2;

    signal B_RGB : std_logic_vector(11 downto 0);
    signal B_ON : std_logic;
    signal B_CLICK : std_logic;

    signal L_MOUSE_ON : std_logic;
begin

    button : entity work.menubutton
        generic map(
            CreateRect(x, y, size_x, size_y)
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => B_RGB,
            O_ON => B_ON,
            O_CLICK => B_CLICK
        );

    L_MOUSE_ON <= CheckCollision(I_CURSOR, I_PIXEL);

    O_RGB <= x"000" when L_MOUSE_ON = '1' else
        B_RGB when B_ON = '1' else
        x"FFF";
end architecture;