library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
entity FlappyBird is
    port (
        I_CLK : in std_logic;
        I_RST_N : in std_logic;
        I_ENABLE_N : in std_logic;

        IO_DATA : inout std_logic;
        IO_MCLK : inout std_logic;

        O_RED : out std_logic_vector(3 downto 0);
        O_GREEN : out std_logic_vector(3 downto 0);
        O_BLUE : out std_logic_vector(3 downto 0);
        O_H_SYNC : out std_logic;
        O_V_SYNC : out std_logic;

        O_LED : out std_logic;
        O_DISP : out std_logic_vector(6 downto 0)
    );
end entity;

architecture behavioral of FlappyBird is
    type STATE is (MENU, NORMAL, TRAINING);
    signal V_V_SYNC : std_logic;
    signal V_PIXEL_ROW : std_logic_vector(9 downto 0);
    signal V_PIXEL_COL : std_logic_vector(9 downto 0);

    signal M_LEFT : std_logic;
    signal M_RIGHT : std_logic;
    signal M_CURSOR_ROW : std_logic_vector(9 downto 0);
    signal M_CURSOR_COL : std_logic_vector(9 downto 0);

    signal G_SCORE : std_logic_vector(11 downto 0) := (others => '0');

    signal G_RGB : std_logic_vector(11 downto 0);
    signal G_TO_MENU : std_logic;
    signal G_DISP : std_logic_vector(6 downto 0);

    signal T_RGB : std_logic_vector(11 downto 0);
    signal T_BUTTON : std_logic_vector(1 downto 0);

    signal L_CLK : std_logic := '1';
    signal L_STATE : STATE := MENU;
    signal L_RGB : std_logic_vector(11 downto 0);
    signal L_CURSOR : T_RECT := CreateRect(0, 0, 0, 0);
    signal L_PIXEL : T_RECT := CreateRect(0, 0, 0, 0);
    signal L_GAME_RST : std_logic := '0';
    signal L_GAME_RST_STATE : std_logic := '0';
    signal L_GAME_ENABLED : std_logic := '0';
    signal L_GAME_ENABLE : std_logic := '0';
    signal L_MENU_ENABLED : std_logic := '0';
    signal L_TRAINING : std_logic := '0';
    signal L_M_RST : std_logic := '0';
    signal L_HIGH_SCORE : std_logic_vector(11 downto 0) := (others => '0');
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
            I_RST => L_M_RST,
            IO_DATA => IO_DATA,
            IO_MCLK => IO_MCLK,
            O_LEFT => M_LEFT,
            O_RIGHT => M_RIGHT,
            O_CURSOR_ROW => M_CURSOR_ROW,
            O_CURSOR_COL => M_CURSOR_COL
        );

    game : entity work.game
        port map(
            I_CLK => L_CLK,
            I_RST => L_GAME_RST,
            I_ENABLE => L_GAME_ENABLE,
            I_TRAINING => L_TRAINING,
            I_V_SYNC => V_V_SYNC,
            I_PIXEL => L_PIXEL,
            I_M_LEFT => M_LEFT,
            O_RGB => G_RGB,
            O_SCORE => G_SCORE,
            O_TO_MENU => G_TO_MENU,
            O_DISP => G_DISP,
            O_LED => O_LED
        );

    titlemenu : entity work.menu
        port map(
            I_ON => L_MENU_ENABLED,
            I_CLK => L_CLK,
            I_V_SYNC => V_V_SYNC,
            I_PIXEL => L_PIXEL,
            I_HIGH_SCORE => L_HIGH_SCORE,
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

    state_machine : process (V_V_SYNC)
    begin
        if (rising_edge(V_V_SYNC)) then
            L_MENU_ENABLED <= '0';
            L_GAME_ENABLED <= '0';
            L_TRAINING <= '0';
            L_GAME_RST_STATE <= '0';
            if (I_RST_N = '0') then
                L_STATE <= MENU;
            else
                case L_STATE is
                    when MENU =>
                        L_MENU_ENABLED <= '1';
                        L_GAME_RST_STATE <= '1';

                        if (T_BUTTON = "01") then
                            L_STATE <= NORMAL;
                        elsif (T_BUTTON = "10") then
                            L_STATE <= TRAINING;
                        end if;
                    when NORMAL =>
                        L_GAME_ENABLED <= '1';

                        if (G_TO_MENU = '1') then
                            L_STATE <= MENU;
                        end if;
                    when TRAINING =>
                        L_GAME_ENABLED <= '1';
                        L_TRAINING <= '1';

                        if (G_TO_MENU = '1') then
                            L_STATE <= MENU;
                        end if;
                    when others =>
                        L_STATE <= MENU;
                end case;
            end if;
        end if;
    end process;

    clk_div : process (I_CLK)
    begin
        if (rising_edge(I_CLK)) then
            L_CLK <= not L_CLK;
        end if;
    end process;

    high_score : process (V_V_SYNC)
    begin
        if (rising_edge(V_V_SYNC)) then
            if (G_SCORE > L_HIGH_SCORE) then
                L_HIGH_SCORE <= G_SCORE;
            else
                L_HIGH_SCORE <= L_HIGH_SCORE;
            end if;
        end if;
    end process;

    L_RGB <= T_RGB when L_STATE = MENU else
        G_RGB when (L_STATE = NORMAL or L_STATE = TRAINING) else
        (others => '0');

    L_PIXEL.X <= '0' & V_PIXEL_COL;
    L_PIXEL.Y <= V_PIXEL_ROW;
    L_GAME_RST <= (not I_RST_N) or L_GAME_RST_STATE;
    L_GAME_ENABLE <= (not I_ENABLE_N) and L_GAME_ENABLED;
    O_V_SYNC <= V_V_SYNC;
    L_M_RST <= (not I_RST_N) or G_TO_MENU;
    O_DISP <= G_DISP when L_GAME_ENABLED = '1' else
        "1111111";
end architecture;