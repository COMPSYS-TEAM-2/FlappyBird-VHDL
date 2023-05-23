library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use ieee.STD_LOGIC_unsigned.all;

entity score is
    port (
        I_CLK : in STD_LOGIC;
        I_RST : in STD_LOGIC;
        I_PipePassed : in STD_LOGIC; -- INPUT FROM PIPE BEING PASSED
        I_Collision : in STD_LOGIC;
        O_ONES : out STD_LOGIC_VECTOR(5 downto 0); -- OUTPUT FOR DISPLAYSCORE.VHD
        O_TENS : out STD_LOGIC_VECTOR(5 downto 0) -- OUTPUT FOR DISPLAYSCORE.VHD
    );
end entity score;
architecture behavioral of score is
    signal L_ONES : STD_LOGIC_VECTOR(5 downto 0) := conv_std_logic_vector(0, 6);
    signal L_TENS : STD_LOGIC_VECTOR(5 downto 0) := conv_std_logic_vector(0, 6);

begin
    -- PROCESS TO UPDATE THE SCORE
    process (I_CLK)
        variable COLLIDED : STD_LOGIC := '0';
        variable INCREMENTED : STD_LOGIC := '0';
        variable V_ONES : STD_LOGIC_VECTOR(5 downto 0) := conv_std_logic_vector(0, 6);
        variable V_TENS : STD_LOGIC_VECTOR(5 downto 0) := conv_std_logic_vector(0, 6);
    begin
        if (rising_edge(I_CLK)) then
            if (I_RST = '1') then
                COLLIDED := '0';
                INCREMENTED := '0';
                V_ONES := conv_std_logic_vector(0, 6);
                V_TENS := conv_std_logic_vector(0, 6);
            elsif (I_COLLISION = '1') then
                COLLIDED := '1';
            elsif (I_PipePassed = '1') then
                if (INCREMENTED = '0' and COLLIDED = '0') then
                    V_ONES := V_ONES + 1;
                    if (V_ONES = conv_std_logic_vector(10, 6)) then
                        V_ONES := conv_std_logic_vector(0, 6);
                        V_TENS := V_TENS + 1;
                    end if;
                    if (V_TENS = conv_std_logic_vector(10, 6)) then
                        V_TENS := conv_std_logic_vector(9, 6);
                        V_ONES := conv_std_logic_vector(9, 6);
                    end if;
                end if;
                INCREMENTED := '1';
                COLLIDED := '0';
            else
                INCREMENTED := '0';
            end if;
            O_ONES <= V_ONES;
            O_TENS <= V_TENS;
        end if;
    end process;
end architecture;