library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;

entity obstacles is
    port (
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_RST : in std_logic;
        I_ENABLE : in std_logic;
        I_PIXEL : in T_RECT;
        I_RANDOM : in std_logic_vector(7 downto 0);
        I_BIRD : in T_RECT;
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_COLLISION : out std_logic;
        O_PIPE_PASSED : out std_logic;
        O_ADD_LIFE : out std_logic
    );
end obstacles;

architecture behavior of obstacles is
    signal A_RGB : std_logic_vector(11 downto 0);
    signal A_COLLISION : std_logic;
    signal A_ON : std_logic;
    signal A_PIPE_PASSED : std_logic;

    signal B_RGB : std_logic_vector(11 downto 0);
    signal B_COLLISION : std_logic;
    signal B_ON : std_logic;
    signal B_PIPE_PASSED : std_logic;
    signal G_RGB : std_logic_vector(11 downto 0);
    signal G_COLLISION : std_logic;
    signal G_ON : std_logic;

    signal L_ADD_LIFE_A : std_logic;
    signal L_ADD_LIFE_B : std_logic;
begin
    pipe_aye : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(680, 11)
        )
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => I_ENABLE,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            I_BIRD => I_BIRD,
            O_RGB => A_RGB,
            O_ON => A_ON,
            O_COLLISION => A_COLLISION,
            O_PIPE_PASSED => A_PIPE_PASSED,
            O_ADD_LIFE => L_ADD_LIFE_A
        );

    pipe_bee : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(1020, 11)
        )
        port map(
            I_CLK => I_CLK,
            I_V_SYNC => I_V_SYNC,
            I_RST => I_RST,
            I_ENABLE => I_ENABLE,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            I_BIRD => I_BIRD,
            O_RGB => B_RGB,
            O_ON => B_ON,
            O_COLLISION => B_COLLISION,
            O_PIPE_PASSED => B_PIPE_PASSED,
            O_ADD_LIFE => L_ADD_LIFE_B
        );

    ground : entity work.ground
        port map(
            I_V_SYNC => I_V_SYNC,
            I_ENABLE => I_ENABLE,
            I_PIXEL => I_PIXEL,
            I_BIRD => I_BIRD,
            O_RGB => G_RGB,
            O_ON => G_ON,
            O_COLLISION => G_COLLISION
        );

    O_RGB <= G_RGB when G_ON = '1' else
        A_RGB when A_ON = '1' else
        B_RGB when B_ON = '1' else
        x"000";

    O_ON <= (A_ON or B_ON or G_ON);
    O_COLLISION <= B_COLLISION or A_COLLISION;
    O_PIPE_PASSED <= A_PIPE_PASSED or B_PIPE_PASSED;
    O_ADD_LIFE <= L_ADD_LIFE_A or L_ADD_LIFE_B;
end architecture;