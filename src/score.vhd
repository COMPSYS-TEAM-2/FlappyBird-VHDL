library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_unsigned.all;

entity score is
    port (
        I_CLK : in std_logic;
        I_RST : in std_logic;
        I_PipePassed : in std_logic; -- INPUT FROM PIPE BEING PASSED
        I_Collision : in std_logic;
        O_ONES : out std_logic_vector(5 downto 0); -- OUTPUT FOR DISPLAYSCORE.VHD
        O_TENS : out std_logic_vector(5 downto 0) -- OUTPUT FOR DISPLAYSCORE.VHD
    );
end entity score;
architecture behavioral of score is
    signal L_ONES : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);
    signal L_TENS : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);

begin
    -- PROCESS TO UPDATE THE SCORE
    process (I_CLK)
        variable COLLIDED : std_logic := '0';
        variable INCREMENTED : std_logic := '0';
        variable V_ONES : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);
        variable V_TENS : std_logic_vector(3 downto 0) := conv_std_logic_vector(0, 4);
    begin
        if (rising_edge(I_CLK)) then
            if (I_RST = '1') then
                COLLIDED := '0';
                INCREMENTED := '0';
                V_ONES := conv_std_logic_vector(0, 4);
                V_TENS := conv_std_logic_vector(0, 4);
            elsif (I_COLLISION = '1') then
                COLLIDED := '1';
            elsif (I_PipePassed = '1') then
                if (INCREMENTED = '0' and COLLIDED = '0') then
                    V_ONES := V_ONES + 1;
                    if (V_ONES = conv_std_logic_vector(10, 4)) then
                        V_ONES := conv_std_logic_vector(0, 4);
                        V_TENS := V_TENS + 1;
                    end if;
                    if (V_TENS = conv_std_logic_vector(10, 4)) then
                        V_TENS := conv_std_logic_vector(9, 4);
                        V_ONES := conv_std_logic_vector(9, 4);
                    end if;
                end if;
                INCREMENTED := '1';
                COLLIDED := '0';
            else
                INCREMENTED := '0';
            end if;
            L_ONES <= V_ONES;
            L_TENS <= V_TENS;
        end if;
    end process;

    O_ONES <= o"60" + L_ONES;
    O_TENS <= o"60" + L_TENS;
end architecture;