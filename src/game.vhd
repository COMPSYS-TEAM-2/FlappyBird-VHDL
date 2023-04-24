library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_CLK : in std_logic;

        IO_DATA : inout std_logic;
        IO_MCLK : inout std_logic;

        O_LED : out std_logic;

        O_RED : out std_logic_vector(3 downto 0);
        O_GREEN : out std_logic_vector(3 downto 0);
        O_BLUE : out std_logic_vector(3 downto 0);
        O_H_SYNC : out std_logic;
        O_V_SYNC : out std_logic
    );
end game;

architecture behavior of game is
    signal S_RGB : std_logic_vector(11 downto 0);

    signal V_V_SYNC : std_logic;
    signal V_PIXEL_ROW : std_logic_vector(9 downto 0);
    signal V_PIXEL_COL : std_logic_vector(9 downto 0);

    signal M_LEFT : std_logic;
    signal M_RIGHT : std_logic;
    signal M_CURSOR_ROW : std_logic_vector(9 downto 0);
    signal M_CURSOR_COL : std_logic_vector(9 downto 0);

    signal L_CLK : std_logic := '1';

begin
    square : entity work.square
        port map(
            I_V_SYNC => V_V_SYNC,
            I_PIXEL_ROW => V_PIXEL_ROW,
            I_PIXEL_COL => V_PIXEL_COL,
            I_CLICK => M_LEFT,
            O_RGB => S_RGB
        );

    video : entity work.VGA_SYNC
        port map(
            I_CLK_25Mhz => L_CLK,
            I_RGB => S_RGB,

            O_RED => O_RED,
            O_GREEN => O_GREEN,
            O_BLUE => O_BLUE,
            O_H_SYNC => O_H_SYNC,
            O_V_SYNC => V_V_SYNC,
            O_PIXEL_ROW => V_PIXEL_ROW,
            O_PIXEL_COL => V_PIXEL_COL
        );

    mouse : entity work.mouse
        port map(
            I_CLK_25Mhz => L_CLK,
            I_RST => '0',
            IO_DATA => IO_DATA,
            IO_MCLK => IO_MCLK,
            O_LEFT => M_LEFT,
            O_RIGHT => M_RIGHT,
            O_CURSOR_ROW => M_CURSOR_ROW,
            O_CURSOR_COL => M_CURSOR_COL
        );

    clk_div : process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            L_CLK <= not L_CLK;
        end if;
    end process;

    O_V_SYNC <= V_V_SYNC;
    O_LED <= M_LEFT or M_RIGHT;
end architecture;