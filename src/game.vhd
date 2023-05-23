library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
use work.RGBValues.BACKGROUND_RGB;

entity game is
    port (
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_RST, I_ENABLE : in std_logic;
        I_TRAINING : in std_logic;
        I_PIXEL : in T_RECT;
        I_M_LEFT : in std_logic;
        O_RGB : out std_logic_vector(11 downto 0);
        O_LED : out std_logic
    );
end game;

architecture behavior of game is
    signal B_RGB : std_logic_vector(11 downto 0);
    signal B_ON : std_logic;
    signal B_BIRD : T_RECT;

    signal OB_RGB : std_logic_vector(11 downto 0);
    signal OB_ON : std_logic;
    signal OB_COLLISION_ON : std_logic;
    signal OB_PIPE_PASSED : std_logic;
    signal OB_ADD_LIFE : std_logic;
    signal OB_GAME_OVER : std_logic;

    signal S_ONES : std_logic_vector(5 downto 0);
    signal S_TENS : std_logic_vector(5 downto 0);

    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal LI_LIVES : std_logic_vector(17 downto 0);
    signal LI_RGB : std_logic_vector(11 downto 0);
    signal LI_ON : std_logic;
    signal LI_GAME_OVER : std_logic;

    signal LF_RANDOM : std_logic_vector(7 downto 0);

    signal L_BACKGROUND_COLOUR : std_logic_vector(11 downto 0) := BACKGROUND_RGB;
    signal L_PLAYING : std_logic;
    signal L_ENABLE : std_logic;
    signal L_PIPE_ENABLE : std_logic;
    signal L_DEAD : std_logic;
    signal L_M_LEFT : std_logic;
begin
    bird : entity work.bird
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => L_ENABLE,
            I_PIXEL => I_PIXEL,
            I_CLICK => L_M_LEFT,
            I_DEAD => L_DEAD,
            O_BIRD => B_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON
        );

    obstacles : entity work.obstacles
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => L_PIPE_ENABLE,
            I_PIXEL => I_PIXEL,
            I_BIRD => B_BIRD,
            I_RANDOM => LF_RANDOM,
            O_RGB => OB_RGB,
            O_ON => OB_ON,
            O_COLLISION => OB_COLLISION_ON,
            O_PIPE_PASSED => OB_PIPE_PASSED,
            O_ADD_LIFE => OB_ADD_LIFE,
            O_GAME_OVER => OB_GAME_OVER
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_V_SYNC,
            I_RVAL => I_M_LEFT,
            O_VAL => LF_RANDOM
        );

    score : entity work.score
        port map(
            I_CLK => I_V_SYNC,
            I_RST => I_RST,
            i_pipePassed => OB_PIPE_PASSED,
            i_collision => OB_COLLISION_ON,
            O_ONES => S_ONES,
            O_TENS => S_TENS
        );

    score_text : entity work.string
        generic map(
            X_CENTER => 639/2,
            Y_CENTER => 24,
            SCALE => 3,
            NUM_CHARS => 2,
            COLOR => x"FFF"
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CHARS => S_TENS & S_ONES,
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    lives : entity work.lives
        port map(
            I_CLK => I_V_SYNC,
            I_RST => I_RST,
            I_ADD_LIFE => OB_ADD_LIFE,
            I_pipePassed => OB_PIPE_PASSED,
            I_collision => OB_COLLISION_ON,
            O_LIVES => LI_LIVES,
            O_GAME_OVER => LI_GAME_OVER
        );

    lives_text : entity work.string
        generic map(
            X_CENTER => 52,
            Y_CENTER => 24,
            SCALE => 3,
            NUM_CHARS => 3,
            COLOR => x"F00",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CHARS => LI_LIVES,
            O_RGB => LI_RGB,
            O_ON => LI_ON
        );

    playing : process (I_V_SYNC)
    begin
        if (rising_edge(I_V_SYNC)) then
            if (I_RST = '1') then
                L_PLAYING <= '0';
            elsif (I_M_LEFT = '1' and I_ENABLE = '1') then
                L_PLAYING <= '1';
            end if;
        end if;
    end process;

    game_over : process (I_V_SYNC)
    begin
        if (rising_edge(I_V_SYNC)) then
            O_LED <= '0';
            if (I_RST = '1') then
                L_DEAD <= '0';
            elsif (I_M_LEFT = '1' and L_DEAD = '1' and OB_GAME_OVER = '1') then
                O_LED <= '1';
            elsif (OB_GAME_OVER = '1' or LI_GAME_OVER = '1') then
                L_DEAD <= '1';
            end if;
        end if;
    end process;

    O_RGB <= S_RGB when (S_ON = '1') else
        LI_RGB when (LI_ON = '1' and I_TRAINING /= '1') else
        B_RGB when (B_ON = '1') else
        OB_RGB when (OB_ON = '1') else
        L_BACKGROUND_COLOUR;
    L_ENABLE <= I_ENABLE and L_PLAYING;

    L_PIPE_ENABLE <= L_ENABLE and not L_DEAD;
    L_M_LEFT <= I_M_LEFT and not L_DEAD;

end architecture;