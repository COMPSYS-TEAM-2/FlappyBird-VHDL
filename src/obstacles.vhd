library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use work.Rectangle.all;
use work.Constantvalues.all;

entity obstacles is
    port (
        I_CLK : in std_logic;
        I_V_SYNC : in std_logic;
        I_RST : in std_logic;
        I_ENABLE : in std_logic;
        I_PIXEL : in T_RECT;
        I_RANDOM : in std_logic_vector(7 downto 0);
        I_BIRD : in T_RECT;
        I_LEVEL_THREE : in std_logic;
        O_RGB : out std_logic_vector(11 downto 0);
        O_ON : out std_logic;
        O_COLLISION : out std_logic;
        O_PIPE_PASSED : out std_logic;
        O_ADD_LIFE : out std_logic;
        O_GAME_OVER : out std_logic;
        O_SHEILD : out std_logic;
        O_LED : out std_logic
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
    signal G_ON : std_logic;

    signal L_ADD_LIFE_A : std_logic;
    signal L_ADD_LIFE_B : std_logic;
    signal L_SLOW_TIME_A : std_logic;
    signal L_SLOW_TIME_B : std_logic;
    signal L_SHEILD_A : std_logic;
    signal L_SHEILD_B : std_logic;
    signal L_SHEILD_O : std_logic;

    signal L_X_VEL : std_logic_vector(9 downto 0) := INITIAL_SPEED;
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
            I_LEVEL_THREE => I_LEVEL_THREE,
            I_X_VEL => L_X_VEL,
            O_RGB => A_RGB,
            O_ON => A_ON,
            O_COLLISION => A_COLLISION,
            O_PIPE_PASSED => A_PIPE_PASSED,
            O_ADD_LIFE => L_ADD_LIFE_A,
            O_SLOW_TIME => L_SLOW_TIME_A,
            O_SHEILD => L_SHEILD_A
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
            I_LEVEL_THREE => I_LEVEL_THREE,
            I_X_VEL => L_X_VEL,
            O_RGB => B_RGB,
            O_ON => B_ON,
            O_COLLISION => B_COLLISION,
            O_PIPE_PASSED => B_PIPE_PASSED,
            O_ADD_LIFE => L_ADD_LIFE_B,
            O_SLOW_TIME => L_SLOW_TIME_B,
            O_SHEILD => L_SHEILD_B
        );
    ground : entity work.ground
        port map(
            I_V_SYNC => I_V_SYNC,
            I_ENABLE => I_ENABLE,
            I_PIXEL => I_PIXEL,
            I_BIRD => I_BIRD,
            O_RGB => G_RGB,
            O_ON => G_ON,
            O_COLLISION => O_GAME_OVER
        );

    process (I_V_SYNC)
        variable PP_COUNTER : std_logic_vector(3 downto 0);
        variable S_COUNTER : std_logic_vector(3 downto 0);
        variable PIPE_PASSED : std_logic;
    begin
        if (rising_edge(I_V_SYNC)) then
            if (I_RST = '1') then
                PIPE_PASSED := '0';
                L_SHEILD_O <= '0';
                L_X_VEL <= INITIAL_SPEED;
                PP_COUNTER := conv_std_logic_vector(0, 4);
            elsif (I_ENABLE = '1') then
                if (L_SLOW_TIME_A = '1' or L_SLOW_TIME_B = '1') then
                    if (L_X_VEL > "01") then
                        L_X_VEL <= '0' & L_X_VEL(9 downto 1);
                    end if;
                end if;
                if (L_SHEILD_A = '1' or L_SHEILD_B = '1') then
                    if (L_SHEILD_O = '1') then
                        S_COUNTER := conv_std_logic_vector(0, 4);
                    else
                        L_SHEILD_O <= '1';
                    end if;
                end if;
                O_LED <= '0';
                if (B_PIPE_PASSED = '1' or A_PIPE_PASSED = '1') then
                    if (PIPE_PASSED /= '1') then
                        O_LED <= '1';
                        PIPE_PASSED := '1';
                        if (PP_COUNTER >= conv_std_logic_vector(4, 4)) then
                            L_X_VEL <= L_X_VEL + PIPE_ACCELERATION;
                            PP_COUNTER := conv_std_logic_vector(0, 4);
                        else
                            PP_COUNTER := PP_COUNTER + conv_std_logic_vector(1, 4);
                        end if;
                        if (L_SHEILD_O = '1') then
                            -- TODO Make Counter reset on collection
                            if (S_COUNTER = conv_std_logic_vector(2, 4)) then
                                L_SHEILD_O <= '0';
                                S_COUNTER := conv_std_logic_vector(0, 4);
                            else
                                S_COUNTER := S_COUNTER + conv_std_logic_vector(1, 4);
                            end if;
                        end if;
                    end if;
                else
                    PIPE_PASSED := '0';
                end if;
            end if;
        end if;
    end process;

    O_RGB <= G_RGB when G_ON = '1' else
        A_RGB when A_ON = '1' else
        B_RGB when B_ON = '1' else
        x"000";

    O_ON <= (A_ON or B_ON or G_ON);
    O_COLLISION <= B_COLLISION or A_COLLISION;
    O_PIPE_PASSED <= A_PIPE_PASSED or B_PIPE_PASSED;
    O_ADD_LIFE <= L_ADD_LIFE_A or L_ADD_LIFE_B;
    O_SHEILD <= L_SHEILD_O;
end architecture;