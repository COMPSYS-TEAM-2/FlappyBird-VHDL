library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game is
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL_ROW : std_logic_vector(9 downto 0);
        I_PIXEL_COL : std_logic_vector(9 downto 0);
        I_M_LEFT : in std_logic;

        O_RGB : out std_logic_vector(11 downto 0);
        O_LED : out std_logic
    );
end game;

architecture behavior of game is
    signal S_X_POS : std_logic_vector(10 downto 0);
    signal S_Y_POS : std_logic_vector(10 downto 0);
    signal S_SIZE : std_logic_vector(9 downto 0);
    signal S_RGB : std_logic_vector(11 downto 0);
    signal S_ON : std_logic;

    signal P_X_A_POS, P_X_B_POS : std_logic_vector(10 downto 0);
    signal P_A_PIPE_GAP_POS, P_B_PIPE_GAP_POS : std_logic_vector(9 downto 0);
    signal P_PIPE_GAP, P_PIPE_WIDTH : std_logic_vector(9 downto 0);
    signal P_RGB : std_logic_vector(11 downto 0);
    signal P_ON : std_logic;

    signal LF_PIPE_GAP : std_logic_vector(7 downto 0);

    signal C_ON : std_logic;

    signal L_CLK : std_logic := '1';

    signal B_COLOUR : std_logic_vector(11 downto 0) := x"2AC";

begin
    square : entity work.square
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL_ROW => I_PIXEL_ROW,
            I_PIXEL_COL => I_PIXEL_COL,
            I_CLICK => I_M_LEFT,
            O_X_POS => S_X_POS,
            O_Y_POS => S_Y_POS,
            O_S_SIZE => S_SIZE,
            O_RGB => S_RGB,
            O_ON => S_ON
        );

    pipes : entity work.pipes
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL_ROW => I_PIXEL_ROW,
            I_PIXEL_COL => I_PIXEL_COL,
            I_PIPE_GAP_POSITION => LF_PIPE_GAP,
            O_X_A_POS => P_X_A_POS,
            O_X_B_POS => P_X_B_POS,
            O_A_PIPE_GAP_POS => P_A_PIPE_GAP_POS,
            O_B_PIPE_GAP_POS => P_B_PIPE_GAP_POS,
            O_PIPE_GAP => P_PIPE_GAP,
            O_PIPE_WIDTH => P_PIPE_WIDTH,
            O_RGB => P_RGB,
            O_ON => P_ON
        );

    -- Define the Linear Feeback Shift Register
    lfsr : entity work.lfsr
        port map(
            I_CLK => I_V_SYNC,
            I_RVAL => I_M_LEFT,
            O_VAL => LF_PIPE_GAP
        );

    collision : entity work.collision
        port map(
            I_VSYNC => I_V_SYNC,
            I_S_X_POS => S_X_POS,
            I_S_Y_POS => S_Y_POS,
            I_S_SIZE => S_SIZE,
            I_P_X_A_POS => P_X_A_POS,
            I_P_X_B_POS => P_X_B_POS,
            I_A_PIPE_GAP_POS => P_A_PIPE_GAP_POS,
            I_B_PIPE_GAP_POS => P_B_PIPE_GAP_POS,
            I_PIPE_GAP => P_PIPE_GAP,
            I_PIPE_WIDTH => P_PIPE_WIDTH,
            O_COL => C_ON
        );

    O_RGB <= S_RGB when (S_ON = '1') else
        P_RGB when (P_ON = '1') else
        B_COLOUR;

    O_LED <= C_ON;

end architecture;