library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;

entity menu is
    port (
        I_ON : in std_logic;

        I_V_SYNC : in std_logic;
        I_PIXEL_ROW : std_logic_vector(9 downto 0);
        I_PIXEL_COL : std_logic_vector(9 downto 0);

        I_M_LEFT : in std_logic;
        I_CURSOR_ROW : std_logic_vector(9 downto 0);
        I_CURSOR_COL : std_logic_vector(9 downto 0);

        O_RGB : out std_logic_vector(11 downto 0)
    );
end menu;

architecture behavior of menu is
    constant size_x : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(80, 11);
    constant size_y : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(40, 10);

    signal L_X_POS : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(639/2, 11) - ('0' & size_x(9 downto 1));
    signal L_Y_POS : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479/2, 10) - ('0' & size_x(9 downto 1));
    signal L_ON : std_logic;
    signal L_MOUSE_ON : std_logic;
begin

    L_MOUSE_ON <= '1' when (((I_CURSOR_ROW - '1' <= I_PIXEL_ROW) and (I_CURSOR_ROW + '1' >= I_PIXEL_ROW)) and ((I_CURSOR_COL - 1 <= I_PIXEL_COL) and (I_CURSOR_COL + 1 >= I_PIXEL_COL))) else
        '0';

    L_ON <= '1' when (('0' & L_X_POS <= '0' & I_PIXEL_COL) and ('0' & I_PIXEL_COL <= '0' & L_X_POS + size_x) -- x_pos - size <= pixel_column <= x_pos + size
        and ('0' & L_Y_POS <= I_PIXEL_ROW) and ('0' & I_PIXEL_ROW <= L_Y_POS + size_y)) else -- y_pos - size <= pixel_row <= y_pos + size
        '0';

    O_RGB <= x"000" when L_MOUSE_ON = '1' else
        x"F00" when L_ON = '1' else
        x"FFF";
end architecture;