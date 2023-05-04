library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
entity FlappyBird is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;

        IO_DATA : inout std_logic;
        IO_MCLK : inout std_logic;

        O_RED : out std_logic_vector(3 downto 0);
        O_GREEN : out std_logic_vector(3 downto 0);
        O_BLUE : out std_logic_vector(3 downto 0);
        O_H_SYNC : out std_logic;
        O_V_SYNC : out std_logic;

        O_LED : out std_logic
    );
end entity;

architecture behavioral of FlappyBird is
    signal V_V_SYNC : std_logic;
    signal V_PIXEL_ROW : std_logic_vector(9 downto 0);
    signal V_PIXEL_COL : std_logic_vector(9 downto 0);

    signal M_LEFT : std_logic;
    signal M_RIGHT : std_logic;
    signal M_CURSOR_ROW : std_logic_vector(9 downto 0);
    signal M_CURSOR_COL : std_logic_vector(9 downto 0);

    signal G_RGB : std_logic_vector(11 downto 0);
    signal T_RGB : std_logic_vector(11 downto 0);
    signal T_BUTTON : std_logic_vector(1 downto 0);

    signal L_CLK : std_logic := '1';
    signal L_STATE : std_logic_vector(1 downto 0) := "00";
    signal L_RGB : std_logic_vector(11 downto 0);
    signal L_CURSOR : T_RECT := CreateRect(0, 0, 0, 0);
    signal L_PIXEL : T_RECT := CreateRect(0, 0, 0, 0);

begin

    video : entity work.VGA_SYNC
        port map(
            I_CLK_25Mhz => L_CLK,
            I_RGB => L_RGB,

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

    game : entity work.game
        port map(
            I_V_SYNC => V_V_SYNC,
            I_PIXEL_ROW => V_PIXEL_ROW,
            I_PIXEL_COL => V_PIXEL_COL,
            I_M_LEFT => M_LEFT,
            O_RGB => G_RGB,
            O_LED => O_LED
        );

    titlemenu : entity work.menu
        port map(
            I_ON => '1',

            I_V_SYNC => V_V_SYNC,
            I_PIXEL => L_PIXEL,

            I_M_LEFT => M_LEFT,
            I_CURSOR => L_CURSOR,

            O_RGB => T_RGB,
            O_BUTTON => T_BUTTON
        );

    mouse_pos : process (V_V_SYNC)
    begin
        if (rising_edge(V_V_SYNC)) then
            L_CURSOR.X <= '0' & M_CURSOR_COL;
            L_CURSOR.Y <= M_CURSOR_ROW;
        end if;
    end process;

    state : process (V_V_SYNC)
    begin
        if (rising_edge(V_V_SYNC)) then
            if (L_STATE = "00") then
                L_STATE <= T_BUTTON;
            end if;
        end if;
    end process;

    clk_div : process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            L_CLK <= not L_CLK;
        end if;
    end process;

    L_RGB <= T_RGB when L_STATE = "00" else
        G_RGB when (L_STATE = "01" or L_STATE = "10") else
        (others => '0');

    L_PIXEL.X <= '0' & V_PIXEL_COL;
    L_PIXEL.Y <= V_PIXEL_ROW;

    O_V_SYNC <= V_V_SYNC;
end architecture;