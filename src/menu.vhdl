library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_signed.all;
use work.Rectangle.all;
use work.constantvalues.all;
use work.RGBValues.all;

entity menu is
    port (
        I_ON : in std_logic;
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;
        I_HIGH_SCORE : in std_logic_vector(11 downto 0);

        I_M_LEFT : in std_logic;
        I_CURSOR : in T_RECT;

        O_RGB : out std_logic_vector(11 downto 0);
        O_BUTTON : out std_logic_vector(1 downto 0)
    );
end menu;

architecture behavior of menu is
    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;
    signal P_CLICK : std_logic;

    signal LB_RGB : std_logic_vector(11 downto 0);
    signal LB_ON : std_logic;
    signal LB_CLICK : std_logic;
    signal LBS_ON : std_logic;

    signal RB_RGB : std_logic_vector(11 downto 0);
    signal RB_ON : std_logic;
    signal RB_CLICK : std_logic;
    signal RBS_ON : std_logic;

    signal TI_RGB : std_logic_vector(11 downto 0);
    signal TI_ON : std_logic;

    signal T_RGB : std_logic_vector(11 downto 0);
    signal T_ON : std_logic;

    signal N_RGB : std_logic_vector(11 downto 0);
    signal N_ON : std_logic;

    signal H_RGB : std_logic_vector(11 downto 0);
    signal H_ON : std_logic;

    signal PT_RGB : std_logic_vector(11 downto 0);
    signal PT_ON : std_logic;

    signal S_MOUSE_ON : std_logic;

    signal L_MODE : std_logic := '0';
begin
    title : entity work.string
        generic map(
            X_CENTER => SCREEN_WIDTH/2,
            Y_CENTER => 50,
            SCALE => 3,
            NUM_CHARS => 11,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           F L A P P Y   B I R D
            I_CHARS => o"1725123131424413223315",
            O_RGB => TI_RGB,
            O_ON => TI_ON
        );

    high_score : entity work.string
        generic map(
            X_CENTER => SCREEN_WIDTH/2,
            Y_CENTER => 100,
            SCALE => 2,
            NUM_CHARS => 13,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           H I G H _ S C O R E : _
            I_CHARS => o"2122202144341430331662" & I_HIGH_SCORE,
            O_RGB => H_RGB,
            O_ON => H_ON
        );

    spriteMouse : entity work.sprite
        port map(
            I_CLK => I_CLK,
            I_X => I_CURSOR.X,
            I_Y => I_CURSOR.Y,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X,
            I_INDEX => o"56",
            O_ON => S_MOUSE_ON
        );

    leftbuttonSprite : entity work.sprite
        port map(
            I_CLK => I_CLK,
            I_X => conv_std_logic_vector(SCREEN_WIDTH/2 - 160 - 16, 11),
            I_Y => conv_std_logic_vector(SCREEN_HEIGHT/2, 10),
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X,
            I_INDEX => o"60",
            O_ON => LBS_ON
        );

    leftbutton : entity work.menubutton
        generic map(
            CreateRect(SCREEN_WIDTH/2 - 160 - 16, 239, 16, 32),
            x"333"
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => LB_RGB,
            O_ON => LB_ON,
            O_CLICK => LB_CLICK
        );

    rightbuttonSprite : entity work.sprite
        port map(
            I_CLK => I_CLK,
            I_X => conv_std_logic_vector(SCREEN_WIDTH/2 + 160, 11),
            I_Y => conv_std_logic_vector(SCREEN_HEIGHT/2, 10),
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X,
            I_INDEX => o"57",
            O_ON => RBS_ON
        );

    rightbutton : entity work.menubutton
        generic map(
            CreateRect(SCREEN_WIDTH/2 + 160, SCREEN_HEIGHT/2, 16, 32),
            x"333"
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => RB_RGB,
            O_ON => RB_ON,
            O_CLICK => RB_CLICK
        );

    training_text : entity work.string
        generic map(
            X_CENTER => SCREEN_WIDTH/2,
            Y_CENTER => SCREEN_HEIGHT/2 + 16,
            SCALE => 3,
            NUM_CHARS => 8,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           T R A I N I N G
            I_CHARS => o"3533122227222720",
            O_RGB => T_RGB,
            O_ON => T_ON
        );

    normal_text : entity work.string
        generic map(
            X_CENTER => SCREEN_WIDTH/2,
            Y_CENTER => SCREEN_HEIGHT/2 + 16,
            SCALE => 3,
            NUM_CHARS => 6,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           N O R M A L
            I_CHARS => o"273033261225",
            O_RGB => N_RGB,
            O_ON => N_ON
        );

    playbutton : entity work.menubutton
        generic map(
            CreateRect(MENU_BUTTON_X, MENU_BUTTON_Y, MENU_BUTTON_SIZE_X, MENU_BUTTON_SIZE_Y),
            MENU_BUTTON_RGB
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_M_LEFT => I_M_LEFT,
            I_CURSOR => I_CURSOR,
            O_RGB => P_RGB,
            O_ON => P_ON,
            O_CLICK => P_CLICK
        );
    playbutton_text : entity work.string
        generic map(
            X_CENTER => (SCREEN_WIDTH/2),
            Y_CENTER => (MENU_BUTTON_Y + MENU_BUTTON_SIZE_Y/2),
            SCALE => 3,
            NUM_CHARS => 4,
            COLOR => x"FFF",
            GAP => 1
        )
        port map(
            I_CLK => I_CLK,
            I_PIXEL_ROW => I_PIXEL.Y,
            I_PIXEL_COL => I_PIXEL.X(9 downto 0),
            --           P L A Y 
            I_CHARS => o"31251242",
            O_RGB => PT_RGB,
            O_ON => PT_ON
        );

    process (I_V_SYNC)
    begin
        if rising_edge(I_V_SYNC) then
            if (LB_CLICK = '1' or RB_CLICK = '1') then
                L_MODE <= not L_MODE;
            end if;
        end if;
    end process;

    O_RGB <= MOUSE_RGB when S_MOUSE_ON = '1' else
        H_RGB when (H_ON = '1') else
        TI_RGB when TI_ON = '1' else
        PT_RGB when PT_ON = '1' else
        P_RGB when P_ON = '1' else
        LB_RGB when LBS_ON = '1' else
        RB_RGB when RBS_ON = '1' else
        T_RGB when T_ON = '1' and L_MODE = '1' else
        N_RGB when N_ON = '1' and L_MODE = '0' else
        MENU_BACKGROUND_RGB;

    O_BUTTON <= "00" when I_ON = '0' else
        "01" when P_CLICK = '1' and L_MODE = '0' else
        "10" when P_CLICK = '1' and L_MODE = '1' else
        "00";
end architecture;