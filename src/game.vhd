library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_CLK : in std_logic;
        I_PB1 : in std_logic;
        I_PB2 : in std_logic;

        IO_DATA : inout std_logic;
        IO_CLK : inout std_logic;

        O_LED : out std_logic;

        O_RED : out std_logic;
        O_GREEN : out std_logic;
        O_BLUE : out std_logic;
        O_H_SYNC : out std_logic;
        O_V_SYNC : out std_logic
    );
end game;

architecture behavior of game is
    signal S_RED : std_logic;
    signal S_GREEN : std_logic;
    signal S_BLUE : std_logic;

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
            I_PB1 => I_PB1,
            I_PB2 => I_PB2,
            I_V_SYNC => V_V_SYNC,
            I_PIXEL_ROW => V_PIXEL_ROW,
            I_PIXEL_COL => V_PIXEL_COL,
            I_CLICK => M_LEFT,

            O_RED => S_RED,
            O_GREEN => S_GREEN,
            O_BLUE => S_BLUE
        );

    video : entity work.VGA_SYNC
        port map(
            clock_25Mhz => L_CLK,
            RED => S_RED,
            GREEN => S_GREEN,
            BLUE => S_BLUE,

            red_out => O_RED,
            green_out => O_GREEN,
            blue_out => O_BLUE,
            vert_sync_out => V_V_SYNC,
            horiz_sync_out => O_H_SYNC,
            pixel_row => V_PIXEL_ROW,
            pixel_column => V_PIXEL_COL
        );

    mouse : entity work.mouse
        port map(
            clock_25Mhz => L_CLK,
            reset => '0',
            mouse_data => IO_DATA,
            mouse_clk => IO_CLK,
            left_button => M_LEFT,
            right_button => M_RIGHT,
            mouse_cursor_row => M_CURSOR_ROW,
            mouse_cursor_column => M_CURSOR_COL
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