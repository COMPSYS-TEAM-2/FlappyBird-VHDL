library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
use work.ConstantValues.all;
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
        O_TO_MENU : out std_logic;
        O_LED : out std_logic;
        O_SCORE : out std_logic_vector(11 downto 0);
        O_DISP : out std_logic_vector(6 downto 0)
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
    signal PU_SHEILD : std_logic;

    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal LI_LIVES : std_logic_vector(17 downto 0);
    signal LI_RGB : std_logic_vector(11 downto 0);
    signal LI_ON : std_logic;
    signal LI_GAME_OVER : std_logic;
    signal LI_ADD_LIFE : std_logic;
    signal LF_RANDOM : std_logic_vector(7 downto 0);
    signal CTS_RGB : std_logic_vector(11 downto 0);
    signal CTS_ON : std_logic;
    signal PA_RGB : std_logic_vector(11 downto 0);
    signal PA_ON : std_logic;
    signal L_BACKGROUND_COLOUR : std_logic_vector(11 downto 0) := BACKGROUND_RGB;
    signal L_PLAYING : std_logic;
    signal L_ENABLE : std_logic;
    signal L_PIPE_ENABLE : std_logic;
    signal L_DEAD : std_logic;
    signal L_M_LEFT : std_logic;
    signal L_LEVEL : std_logic_vector(1 downto 0);
    signal L_GRAVITY_TRIGGER : std_logic;
    signal L_S_PIPE : std_logic;
    signal L_ONES_DISPLAY : std_logic_vector(6 downto 0);
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
            I_GRAVITY => L_GRAVITY_TRIGGER,
            I_SHEILD => PU_SHEILD,
            O_BIRD => B_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON
        );

    level_to_seven_seg_inst : entity work.LEVEL_TO_SEVEN_SEG
        port map(
            I_REV_GRAVITY => L_GRAVITY_TRIGGER,
            I_S_PIPE => L_S_PIPE,
            O_DISPLAY => L_ONES_DISPLAY
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
            I_LEVEL_THREE => L_S_PIPE,
            O_RGB => OB_RGB,
            O_ON => OB_ON,
            O_COLLISION => OB_COLLISION_ON,
            O_PIPE_PASSED => OB_PIPE_PASSED,
            O_ADD_LIFE => OB_ADD_LIFE,
            O_GAME_OVER => OB_GAME_OVER,
            O_SHEILD => PU_SHEILD,
            O_LED => O_LED
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_V_SYNC,
            I_RVAL => I_M_LEFT,
            O_VAL => LF_RANDOM
        );

    getLevel : entity work.level
        port map(
            I_CLK => I_V_SYNC,
            I_SCORE => S_TENS,
            O_LEVEL => L_LEVEL
        );
    leveltrig_inst : entity work.levelTrig
        port map(
            I_CLK => I_CLK,
            I_LEVEL => L_LEVEL,
            I_TRAINING => I_TRAINING,
            O_REV_GRAVITY => L_GRAVITY_TRIGGER,
            O_S_PIPE => L_S_PIPE
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
            I_SHEILD => PU_SHEILD,
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

    click_to_start : entity work.string
        generic map(
            X_CENTER => SCREEN_WIDTH/2,
            Y_CENTER => 400,
            SCALE => 3,
            NUM_CHARS => 14,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           C L I C K _ T O _ S T A R T
            I_CHARS => o"1425221424443530443435123335",
            O_RGB => CTS_RGB,
            O_ON => CTS_ON
        );

    pause : entity work.string
        generic map(
            X_CENTER => 610,
            Y_CENTER => 24,
            SCALE => 3,
            NUM_CHARS => 1,
            COLOR => x"FFF",
            GAP => 0
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            I_CHARS => o"61",
            O_RGB => PA_RGB,
            O_ON => PA_ON
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
        variable M_DOWN : std_logic := '0';
    begin
        if (rising_edge(I_V_SYNC)) then
            O_SCORE <= (others => '0');
            O_TO_MENU <= '0';
            if (I_RST = '1') then
                M_DOWN := '0';
                L_DEAD <= '0';
            elsif (I_M_LEFT = '1' and L_DEAD = '1' and OB_GAME_OVER = '1') then
                M_DOWN := '1';
            elsif (I_M_LEFT = '0' and M_DOWN = '1') then
                O_TO_MENU <= '1';
                if (I_TRAINING = '0') then
                    O_SCORE <= S_TENS & S_ONES;
                end if;
                M_DOWN := '0';
            elsif (OB_GAME_OVER = '1' or LI_GAME_OVER = '1') then
                L_DEAD <= '1';
            end if;
        end if;
    end process;

    O_RGB <= PA_RGB when (PA_ON = '1' and I_ENABLE = '0') else
        CTS_RGB when (CTS_ON = '1' and L_PLAYING = '0') else
        S_RGB when (S_ON = '1') else
        LI_RGB when (LI_ON = '1') else
        B_RGB when (B_ON = '1') else
        OB_RGB when (OB_ON = '1') else
        L_BACKGROUND_COLOUR;

    L_ENABLE <= I_ENABLE and L_PLAYING;
    L_PIPE_ENABLE <= L_ENABLE and not L_DEAD;
    L_M_LEFT <= I_M_LEFT and not L_DEAD;
    O_DISP <= L_ONES_DISPLAY;

end architecture;