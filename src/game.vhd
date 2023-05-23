library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Rectangle.all;
use work.RGBValues.BACKGROUND_RGB;

entity game is
    port (
        I_CLK : in STD_LOGIC;
        I_V_SYNC : in STD_LOGIC;
        I_RST, I_ENABLE : in STD_LOGIC;
        I_TRAINING : in STD_LOGIC;
        I_PIXEL : in T_RECT;
        I_M_LEFT : in STD_LOGIC;
        O_RGB : out STD_LOGIC_VECTOR(11 downto 0);
        O_LED : out STD_LOGIC
    );
end game;

architecture behavior of game is
    signal B_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal B_ON : STD_LOGIC;
    signal B_BIRD : T_RECT;

    signal P_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal P_ON : STD_LOGIC;
    signal P_COLLISION_ON : STD_LOGIC;
    signal P_PIPE_PASSED : STD_LOGIC;

    signal S_ONES : STD_LOGIC_VECTOR(5 downto 0);
    signal S_TENS : STD_LOGIC_VECTOR(5 downto 0);

    signal S_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal S_ON : STD_LOGIC;

    signal LI_LIVES : STD_LOGIC_VECTOR(17 downto 0);
    signal LI_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal LI_ON : STD_LOGIC;
    signal LI_GAME_OVER : STD_LOGIC;

    signal LF_RANDOM : STD_LOGIC_VECTOR(7 downto 0);

    signal L_BACKGROUND_COLOUR : STD_LOGIC_VECTOR(11 downto 0) := BACKGROUND_RGB;
    signal L_PLAYING : STD_LOGIC;
    signal L_ENABLE : STD_LOGIC;

    signal L_LEVEL : std_logic_vector(1 downto 0);
begin
    bird : entity work.bird
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => L_ENABLE,
            I_PIXEL => I_PIXEL,
            I_CLICK => I_M_LEFT,
            O_BIRD => B_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON
        );

    obstacles : entity work.obstacles
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => L_ENABLE,
            I_PIXEL => I_PIXEL,
            I_BIRD => B_BIRD,
            I_RANDOM => LF_RANDOM,
            O_RGB => P_RGB,
            O_ON => P_ON,
            O_COLLISION => P_COLLISION_ON,
            O_PIPE_PASSED => P_PIPE_PASSED
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

    score : entity work.score
        port map(
            I_CLK => I_V_SYNC,
            I_RST => I_RST,
            i_pipePassed => P_PIPE_PASSED,
            i_collision => P_COLLISION_ON,
            O_ONES => S_ONES,
            O_TENS => S_TENS
        );

    score_text : entity work.STRING
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
            I_ADD_LIFE => '0',
            I_pipePassed => P_PIPE_PASSED,
            I_collision => P_COLLISION_ON,
            O_LIVES => LI_LIVES,
            O_GAME_OVER => LI_GAME_OVER
        );

    lives_text : entity work.STRING
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

    O_RGB <= S_RGB when (S_ON = '1') else
        LI_RGB when (LI_ON = '1' and I_TRAINING /= '1') else
        B_RGB when (B_ON = '1') else
        P_RGB when (P_ON = '1') else
        L_BACKGROUND_COLOUR;
    L_ENABLE <= I_ENABLE and L_PLAYING;
	 
end architecture;