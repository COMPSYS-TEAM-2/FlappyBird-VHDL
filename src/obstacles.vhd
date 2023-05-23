library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;

entity obstacles is
    port (
        I_CLK : in STD_LOGIC;
        I_V_SYNC : in STD_LOGIC;
        I_RST : in STD_LOGIC;
        I_ENABLE : in STD_LOGIC;
        I_PIXEL : in T_RECT;
        I_RANDOM : in STD_LOGIC_VECTOR(7 downto 0);
        I_BIRD : in T_RECT;
        O_RGB : out STD_LOGIC_VECTOR(11 downto 0);
        O_ON : out STD_LOGIC;
        O_COLLISION : out STD_LOGIC;
        O_PIPE_PASSED : out STD_LOGIC
    );
end obstacles;

architecture behavior of obstacles is
    signal A_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal A_COLLISION : STD_LOGIC;
    signal A_ON : STD_LOGIC;
    signal A_PIPE_PASSED : STD_LOGIC;

    signal B_RGB : STD_LOGIC_VECTOR(11 downto 0);
    signal B_COLLISION : STD_LOGIC;
    signal B_ON : STD_LOGIC;
    signal B_PIPE_PASSED : STD_LOGIC;
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
            O_PIPE_PASSED => A_PIPE_PASSED

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
            O_PIPE_PASSED => B_PIPE_PASSED
        );

    O_RGB <= A_RGB when A_ON = '1' else
        B_RGB when B_ON = '1' else
        x"000";

    O_ON <= A_ON or B_ON;
    O_COLLISION <= B_COLLISION or A_COLLISION;
    O_PIPE_PASSED <= A_PIPE_PASSED or B_PIPE_PASSED;
end architecture;