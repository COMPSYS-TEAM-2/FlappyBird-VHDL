library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;

entity obstacles is
    port (
        I_V_SYNC : in std_logic;
        I_PIXEL : in T_RECT;
        I_RANDOM : in std_logic_vector(7 downto 0);
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_COLLISION : out std_logic
    );
end obstacles;

architecture behavior of obstacles is
    signal A_RGB : std_logic_vector(11 downto 0);
    signal B_RGB : std_logic_vector(11 downto 0);
    signal A_ON : std_logic;
    signal B_ON : std_logic;
begin
    pipe_a : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(680, 11)
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            O_RGB => A_RGB,
            O_ON => A_ON
        );

    pipe_b : entity work.pipe
        generic map(
            X_START => CONV_STD_LOGIC_VECTOR(1000, 11)
        )
        port map(
            I_V_SYNC => I_V_SYNC,
            I_PIXEL => I_PIXEL,
            I_PIPE_GAP_POSITION => I_RANDOM,
            O_RGB => B_RGB,
            O_ON => B_ON
        );

    O_RGB <= A_RGB when A_ON = '1' else
        B_RGB when B_ON = '1' else
        x"000";

    O_ON <= A_ON or B_ON;
    O_COLLISION <= '0';
end architecture;