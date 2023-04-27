library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL_ROW : std_logic_vector(9 downto 0);
        I_PIXEL_COL : std_logic_vector(9 downto 0);
        I_M_LEFT : in std_logic;

        O_RGB : out std_logic_vector(11 downto 0)
    );
end game;

architecture behavior of game is
    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal L_RGB : std_logic_vector(11 downto 0);

begin
    square : entity work.square
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL_ROW => I_PIXEL_ROW,
            I_PIXEL_COL => I_PIXEL_COL,
            I_CLICK => I_M_LEFT,
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    O_RGB <= S_RGB when (S_ON = '1') else
        x"2AC";
end architecture;